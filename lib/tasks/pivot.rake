namespace :db do
  task :pivot => :environment do
    schema = Mongoid::Config.master[:schema_info]

    pivots = Dir[File.join('db', 'pivots', '*.rb')]

    previous_pivots = schema.find.map {|p| p['file']}

    pivots_to_run = (pivots - previous_pivots).sort

    def log(str)
      puts " * #{str}"
    end

    pivots_to_run.each do |pivot|
      start = Time.now
      load(pivot)
      puts "#{pivot} - #{(Time.now - start).to_i}s"
      schema.insert(file: pivot, at: Time.now)
    end
  end
end
