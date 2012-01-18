# Load the rails application
require File.expand_path('../application', __FILE__)

env_file = Rails.root.join('.env')
if File.exist?(env_file)
  puts "reading configuration #{env_file}"
  File.readlines(env_file).each do |line|
    next if line =~ /^\s*$/
    key, val = line.split('=', 2)
    ENV[key.strip] ||= val.strip
  end
end

# Initialize the rails application
Minefold::Application.initialize!
