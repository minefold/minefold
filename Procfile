web:    bundle exec rails server thin --port $PORT
worker: QUEUE=critical,high,mailer,low INTERVAL=1 bundle exec rake resque:work
