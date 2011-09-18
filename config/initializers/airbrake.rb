Airbrake.configure do |config|
  config.api_key = '2a986c2b8d31075b30f812baeabb97f7'
  config.ignore << 'Mongoid::Errors::DocumentNotFound'
end
