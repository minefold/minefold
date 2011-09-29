web: bundle exec rails server thin -p $PORT
worker: bundle exec rake environment resque:work QUEUE=critical,high,mailer,low INTERVAL=1
