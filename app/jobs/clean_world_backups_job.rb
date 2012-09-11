class CleanWorldBackupsJob < Job
  @queue = :low

  def perform!
    file_limit = (ENV['FILE_LIMIT'] || 10000).to_i
    all_files = page_world_files('minefold-production-worlds', '', file_limit)
    all_files += page_world_files('minefold-production', 'world-backups', file_limit)

    b = backups all_files

    # b.select{|f| f[:key] =~ /4ec7187fa3f63e0001000134/ }.sort{|a,b| b[:time] <=> a[:time]}.each do |f|
    #   puts "#{f[:time]} #{f[:content_length]}"
    # end


    puts "#{b.size} backups found (#{sum_gb b} Gb)"

    ## retention
    # all for an hour
    # hourly for 2 days
    # daily for 14 days

    grouped = b.each_with_object({}) do |backup, hash|
      hash[backup[:world_id]] ||= []
      hash[backup[:world_id]] << backup
    end

    to_delete = []

    grouped.each do |world_id, backups|
      # p world_id, backups

      rest = backups.sort_by {|b| -b[:time].to_i }
      puts "#{world_id}: (#{backups.size})"

      # all for an hour
      period_end = rest.first[:time] - 1.hour
      in_period, rest = rest.partition {|b| b[:time] > period_end }
      puts "  all #{period_end}:"
      in_period.each {|b| puts "    #{b[:time]} #{b[:key]}"}

      # hourly for 2 days
      period_end -= 2.days
      in_period, rest = rest.partition {|b| b[:time] > period_end  }
      in_period.group_by {|b| b[:hour] }.each do |hour, backups|
        puts " hourly (#{hour}):"
        backups.each.with_index do |b, i|
          delete = i > 0
          to_delete << b if delete
          puts "    #{b[:time]} #{b[:key]} #{'delete' if delete}"
        end
      end

      # daily for 14 days
      period_end -= 14.days
      in_period, rest = rest.partition{|b| b[:time] > period_end }
      in_period.group_by {|b| b[:day] }.each do |day, backups|
        puts " daily (#{day}):"
        backups.each.with_index do |b, i|
          delete = i > 0
          to_delete << b if delete
          puts "    #{b[:time]} #{b[:key]} #{'delete' if delete}"
        end
      end

      # remove the rest
      in_period = rest
      puts " older than (#{period_end}):"
      in_period.each.with_index do |b, i|
        delete = true
        to_delete << b if delete
        puts "    #{b[:time]} #{b[:key]} #{'delete' if delete}"
      end
    end

    puts "Deleting #{to_delete.size} files (#{sum_gb to_delete} Gb)"

    i = 0
    to_delete.each do |backup|
      i += 1
      puts "  delete (#{i}/#{to_delete.size}): #{backup[:key]}" unless ENV['DRY_RUN']
      # backup[:file].destroy # unless ENV['DRY_RUN']
    end

    puts "Deleting #{to_delete.size} files (#{sum_gb to_delete} Gb)"
  end

  def storage
    @storage ||= ::Fog::Storage.new provider: 'AWS',
                         aws_access_key_id: ENV['S3_KEY'],
                     aws_secret_access_key: ENV['S3_SECRET']
  end

  def sum_gb backups
    (backups.inject(0) {|acc, b| acc + b[:content_length] }) / 1024.0 / 1024.0 / 1024.0
  end

  def page_world_files key, prefix = '', limit = 10000
    dir = storage.directories.create key: key #  ENV['WORLDS_BUCKET']

    all_files = []
    files = dir.files.all(prefix: prefix)
    truncated = files.is_truncated

    all_files += files.to_a

    while truncated && all_files.size < limit
      pid, bytes_used = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{Process::pid}"`.
        chomp.
        split(/\s+/).
        map {|s| s.strip.to_i}
      
      puts "#{all_files.size} files (pid: #{pid} ram: #{(bytes_used / 1024.0).round(1)} Mb) s3://#{key}/#{prefix}"
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
