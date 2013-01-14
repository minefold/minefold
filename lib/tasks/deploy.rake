task :deploy do
  sh('rspec') and
  sh('git push origin') and
  sh('git push production')
end
