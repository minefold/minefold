namespace :resque do
  task :setup do
    Bundler.require :worker
  end
end
