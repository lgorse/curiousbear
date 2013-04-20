web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

worker: bundle exec sidekiq -q deltas -q default -q terminate

