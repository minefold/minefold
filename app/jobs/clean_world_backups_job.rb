class CleanWorldBackupsJob < Job
  @queue = :low

  def perform!
    all_files = page_world_files
    # all_files.each{|f| puts f.key }

    b = backups all_files

    # b.select{|f| f[:key] =~ /4ec7187fa3f63e0001000134/ }.sort{|a,b| b[:time] <=> a[:time]}.each do |f|
    #   puts "#{f[:time]} #{f[:content_length]}"
    # end


    puts "#{b.size} backups found (#{sum_gb b})"

    ## retention
    # all for an hour
    # hourly for a day
    # daily forever

    grouped = b.each_with_object({}) do |backup, hash|
      day = backup[:time].strftime('%Y-%m-%d')

      hash[backup[:world_id]] ||= []
      hash[backup[:world_id]] << backup
    end

    to_delete = []

    grouped.each do |world_id, backups|
      # p world_id, backups

      rest = backups.sort_by {|b| -b[:time].to_i }
      puts "#{world_id}: (#{backups.size})"

      period_end = rest.first[:time] - 1.hour
      in_period, rest = rest.partition {|b| b[:time] > period_end }
      puts "  all:"
      in_period.each {|b| puts "    #{b[:time]} #{b[:key]}"}

      period_end -= 1.day
      in_period, rest = rest.partition {|b| b[:time] > period_end  }
      in_period.group_by {|b| b[:hour] }.each do |hour, backups|
        puts " hourly (#{hour}):"
        backups.each.with_index do |b, i|
          delete = i > 0
          to_delete << b if delete
          puts "    #{b[:time]} #{b[:key]} #{'delete' if delete}"
        end
      end

      in_period = rest.select{|b| b[:time] < period_end }
      in_period.group_by {|b| b[:day] }.each do |day, backups|
        puts " daily (#{day}):"
        backups.each.with_index do |b, i|
          delete = i > 0
          to_delete << b if delete
          puts "    #{b[:time]} #{b[:key]} #{'delete' if delete}"
        end
      end
    end

    puts "Deleting #{to_delete.size} files (#{sum_gb to_delete})"

    to_delete.each do |backup|
      puts "  delete: #{backup[:key]}"
      backup[:file].destroy
    end
  end

  def storage
    @storage ||= Fog::Storage.new provider: 'AWS',
                         aws_access_key_id: ENV['S3_KEY'],
                     aws_secret_access_key: ENV['S3_SECRET']
  end

  def sum_gb backups
    (backups.inject(0) {|acc, b| acc + b[:content_length] }) / 1024.0 / 1024.0 / 1024.0
  end

  def page_world_files
    dir = storage.directories.create key: 'minefold.production.worlds' #  ENV['WORLDS_BUCKET']

    all_files = []
    files = dir.files.all
    truncated = files.is_truncated

    all_files += files.to_a

    while truncated
      set = dir.files.all( :marker => files.last.key )
      all_files += set.to_a
      truncated = set.is_truncated
    end
    all_files
  end

  def backups files
    puts "#{files.size} files found"

    files.map do |f|
      f.key =~ /([a-z0-9]+)\.([0-9]+)\.tar\.gz/i
      if $2
        time = Time.at($2.to_i)
        {
               key: f.key,
              file: f,
    content_length: f.content_length,
          world_id: $1,
              time: time,
              hour: time.strftime('%Y-%m-%d %H'),
               day: time.strftime('%Y-%m-%d')
        }
      else
        nil
      end
    end.compact
  end
end
