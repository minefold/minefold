web: bundle exec rails server thin -p $PORT
worker: QUEUE=mailer rake environment resque:work