class ScoreServersJob < Job

  def perform!
    Server.find_each do |server|
      score = server.votes.count
      $redis.zadd 'serverlist', score, server.id
    end
  end

end
