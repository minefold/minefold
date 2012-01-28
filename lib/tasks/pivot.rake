class Pivoter
  attr_reader :schema, :pivots, :previous_pivots, :pivots_to_run
  def initialize dir
    @schema = Mongoid::Config.master[:schema_info]
    @pivots = Dir[File.join(dir, '*.rb')].sort
    @previous_pivots = schema.find.map {|p| p['file']}.sort
    @pivots_to_run = (pivots - previous_pivots).sort
  end
  
  def record_run pivot
    if schema.find({ file: pivot }).first
      puts "#{pivot} already run"
    else
      schema.insert(file: pivot, at: Time.now)
    end
  end
end

namespace :db do
  namespace :pivot do
    desc "Run outstanding pivots"
    task :run => :environment do
      pivoter.pivots_to_run.each do |pivot|
        start = Time.now
        load(pivot)
        puts "#{pivot} - #{(Time.now - start).to_i}s"
        pivoter.record_run pivot
      end
    end
  
    desc "Add pivot to the database without running it"
    task :fake, [:pivot] => :environment do |t, args|
      pivot = args[:pivot]
      raise "Unknown pivot #{pivot_to_fake}" unless File.exists? pivot
    
      pivoter.record_run pivot
    end
  
    desc "Show pivots"
    task :list => :environment do
      puts "PREVIOUS PIVOTS" if pivoter.previous_pivots.any?
      pivoter.previous_pivots.each {|pivot| log pivot}
      
      puts "\nPIVOTS TO RUN" if pivoter.pivots_to_run.any?
      pivoter.pivots_to_run.each {|pivot| log pivot }
    end
    
    def log(str)
      puts " * #{str}"
    end
    
    def pivoter
      @pivoter ||= Pivoter.new File.join('db', 'pivots')
    end
  end
end