class Api::ShotsController < Api::ApiController

  skip_before_filter :http_auth
  before_filter :api_key_auth

  def create
    sha = Digest::SHA1.hexdigest params[:shot].tempfile.read

    # gaurd against confused client
    if Shot.where(sha: sha, creator_id: current_user.id).first
      return render status: :ok, text: "already uploaded: #{sha}\n"
    end

    shot = Shot.new
    shot.creator = current_user
    shot.original_filename = params[:shot].original_filename
    shot.file = params[:shot]
    shot.sha = sha
    shot.save!

    track 'uploaded shot', source: request.headers['User-Agent']
    render status: :ok, text: "uploaded: #{sha}\n"
  end

  def index
    shots = Shot.where(creator_id: current_user.id)
    render status: :ok, json: {shots: shots}
  end

end