Rails.configuration.middleware.use RailsWarden::Manager do |warden|
  warden.default_strategies :password
  warden.failure_app = SessionsController

  warden.serialize_into_session {|user| user.id.to_s}
  warden.serialize_from_session {|id| User.find(id)}
end

Warden::Strategies.add(:password) do

  # TODO: HTTP_AUTH
  def valid?
    valid_request? and
      params[:user] && params[:user][:email] and params[:user][:password]
  end

  def authenticate!
    user = User.first(:email => params[:user][:email])

    if validate(user) {|user| user.password == params[:user][:password]}
      success! user
    else
      fail :invalid
    end
  end

private

  def valid_request?
    params[:controller] == 'sessions' and request.post?
  end

  def validate(user, &blk)
    user and yield(user)
  end
end
