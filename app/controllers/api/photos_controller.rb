class Api::PhotosController < Api::ApiController
  respond_to :json

  skip_before_filter :http_auth
  before_filter :api_key_auth
  # prepend_before_filter :authenticate_user!

  def create
    Resque.enqueue PhotoUploadJob, current_user.id, params[:photo][:remote_file_url]

    track 'uploaded photo', source: request.headers['User-Agent']

    render status: :ok, text: "scheduled: #{params[:photo][:remote_file_url]}"
  end

  def index
    respond_with current_user.photos.unscoped
  end

end