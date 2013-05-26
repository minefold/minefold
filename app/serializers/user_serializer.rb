class UserSerializer < Serializer

  def payload
    o = super
    o[:username] = object.username
  end

end
