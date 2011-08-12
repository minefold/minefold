web: bundle exec rails server thin -p $PORT
worker: bundle exec rake environment resque:work QUEUE=critical,mailer,high,low INTERVAL=1
