# Load the rails application
require File.expand_path('../application', __FILE__)

if evars = File.expand_path('../env.yml', __FILE__) and File.exist?(evars)
  YAML.load_file(evars).each {|key, val| ENV[key.to_s.upcase] ||= val.to_s}
end

# Initialize the rails application
Minefold::Application.initialize!
