class Api::ApiController < ActionController::Base
  include Mixpanel

  before_filter :http_auth, except: [:upload_policy]
  layout nil

  def key
    render json: { api_key: current_user.authentication_token }
  end

  def upload_policy
    @policy = S3UploadPolicy.new ENV['S3_KEY'],
                                 ENV['S3_SECRET'],
                                 ENV['UPLOADS_BUCKET']

    @policy.key = params[:key]
    @policy.content_type = params[:contentType]

    render layout: false
  end

  def http_auth
    return if current_user

    @current_user = authenticate_with_http_basic do |username, password|
      user = User.by_email_or_username(username).first
      user if user && user.valid_password?(password)
    end

    render status: :unauthorized, text: "HTTP Basic Auth required" unless @current_user
  end

  def api_key_auth
    return if current_user

    render status: 403, text: "API key required" unless request.headers['Api-key'] &&
      @current_user = User.where(authentication_token: request.headers['Api-key']).first
  end
end