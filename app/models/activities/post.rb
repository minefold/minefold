class Activities::Post < Activity

  def self.for(post)
    new(actor: post.author, subject: post, target: post.server)
  end

end
