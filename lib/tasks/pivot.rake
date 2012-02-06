require 'pivot'

namespace :db do

  desc "Run outstanding pivots"
  task :pivot => :environment do
    Pivot.pending.each do |pivot|
      puts pivot
      bm = pivot.run!
      $stderr.puts bm.to_s
    end
  end

  namespace :pivots do
    desc "Previously run pivots"
    task :previous => :environment do
      Pivot.previous.each {|p| puts "#{p}: #{p.name}" }
    end

    desc "Pending pivots"
    task :pending => :environment do
      Pivot.pending.each {|p| puts "#{p}: #{p.name}" }
    end

    desc "Add pivot to the database without running it"
    task :fake, [:pivot] => :environment do |t, args|
      pivot = Pivot.new(args[:pivot])

      raise "Unknown pivot #{pivot}" unless File.exists?(pivot)

      pivot.record!
    end

    desc "Runs the last pivot again"
    task :rerun => :environment do
      pivot = Pivot.previous.last
      puts pivot
      time = pivot.run!
      $stderr.puts time.to_s
    end

  end
end