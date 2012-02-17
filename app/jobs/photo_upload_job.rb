class PhotoUploadJob
  @queue = :low

  def self.perform(creator_id, remote_file_url)
    user = User.find(creator_id)
    new(user, remote_file_url).process!
  end

  def initialize(user, remote_file_url)
    @user = user
    @remote_file_url = remote_file_url
  end

  def process!
    puts "Processing PhotoUpload##{@remote_file_url} from user:#{@user.username}"

    photo = Photo.new
    photo.remote_file_url = @remote_file_url
    photo.creator = @user
    photo.save!
  end
end
