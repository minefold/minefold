task "resque:setup" => :environment do
  Bundler.require :worker
end
