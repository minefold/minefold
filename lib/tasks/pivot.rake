namespace :db do
  task :pivot => :environment do
    abort 'Need to specify PIVOT env var' unless ENV['PIVOT']
    
    filename = "#{ENV['PIVOT']}.rb"
    load File.join('db', 'pivots', filename)
  end
end
