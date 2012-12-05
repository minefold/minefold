web:       bundle exec rails server thin --port $PORT
worker:    bundle exec rake resque:work QUEUE=critical,high,mailer,low
scheduler: bundle exec rake resque:scheduler
