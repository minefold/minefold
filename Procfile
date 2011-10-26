web:    bundle exec rails server thin --port $PORT
worker: bundle exec rake environment resque:work QUEUE=critical,high,mailer,low INTERVAL=1
