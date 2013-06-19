web:    bundle exec puma --threads 0:16 --port $PORT
worker: env TERM_CHILD=1 QUEUE=critical,high,low RESQUE_TERM_TIMEOUT=10 bundle exec rake resque:work
