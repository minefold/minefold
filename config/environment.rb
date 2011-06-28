# Load the rails application
require File.expand_path('../application', __FILE__)

# Simulate Heroku-style ENV var loading
if vars = File.expand_path('../env.yml', __FILE__) and File.exist?(vars)
  YAML.load_file(vars)[Rails.env].
    each {|key, var| ENV[key.to_s.upcase] ||= var.to_s}
end

# Initialize the rails application
Minefold::Application.initialize!
