class PhotoUploadJob < Job
  @queue = :low

  def initialize(creator_id, remote_file_url)
    @user = User.find(creator_id)
    @remote_file_url = remote_file_url
  end

  def perform!
    photo = Photo.new
    photo.remote_file_url = @remote_file_url
    photo.creator = @user
    photo.save!

    Events::PublishedPhoto.create(source: photo.creator, target: photo)
  end
end
