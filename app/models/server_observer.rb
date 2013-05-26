class ServerObserver < ActiveRecord::Observer

  def after_save(server)
    Resque.enqueue(PusherJob, server.channel_name, 'changed',
      ServerSerializer.new(server).payload
    )
  end

end
