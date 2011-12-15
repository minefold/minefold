namespace :db do
  task :pivot => :environment do
    abort 'Need to specify PIVOT env var' unless ENV['PIVOT']
    
    filename = "#{ENV['PIVOT']}.rb"
    
    def log(str)
      puts " * #{str}"
    end
    
    start = Time.now
    load File.join('db', 'pivots', filename)
    
    puts
    puts "#{(Time.now - start).to_i} seconds"
  end
end
