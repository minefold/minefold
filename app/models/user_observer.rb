class UserObserver < Mongoid::Observer

  TOKEN_LENGTH = 6

  def before_create(user)
    user.verification_token = free_token(:verification_token)
    user.invite_token = free_token(:invite_token)
  end

  def free_token(field)
    begin
      token = rand(36 ** TOKEN_LENGTH).to_s(36)
    end while token_exists?(field, token)
    token
  end
  
  def token_exists?(field, token)
    User.where("#{field}" => token).exists?
  end

end
