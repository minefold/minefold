class Api::PhotosController < Api::ApiController
  respond_to :json

  skip_before_filter :http_auth
  before_filter :api_key_auth
  # prepend_before_filter :authenticate_user!

  def create
    sha = Digest::SHA1.hexdigest params[:photo].tempfile.read

    # gaurd against confused client
    if Photo.unscoped.where(sha: sha, creator_id: current_user.id).first
      return render status: :ok, text: "already uploaded: #{sha}\n"
    end

    photo = Photo.new
    photo.creator = current_user
    photo.file = params[:photo]
    photo.sha = sha
    photo.save!

    track 'uploaded photo', source: request.headers['User-Agent']

    render status: :ok, text: "uploaded: #{sha}\n"
  end

  def index
    respond_with current_user.photos.unscoped
  end

end