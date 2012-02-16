class WorldUploadJob
  @queue = :low

  def self.perform(world_upload_id)
    upload = WorldUpload.find(world_upload_id)
    new(upload).process!
  end

  def initialize(upload)
    @upload = upload
  end

  def process!
    puts "Processing WorldUpload##{@upload.id}"

    puts "Downloading #{@upload.s3_key}"
    @upload.download!

    puts "Extracting #{@upload.uploaded_archive_path} to #{@upload.extraction_path}"
    @upload.extract!

    puts "Parsing seed from #{@upload.level_dat_path}"
    @upload.parse_seed!

    puts "Building archive"
    @upload.build!

    puts "Uploading archive"
    @upload.upload!

    puts "Saving WorldUpload##{@upload.id}"
    @upload.save!

    puts "Done"

    pusher.trigger('success', @upload.attributes)

  rescue WorldUpload::InvalidUploadError => e
    pusher.trigger('error', e.message)

  rescue WorldUpload::UnreadableUploadError => e
    pusher.trigger('error', e.message)

  rescue => e
    raise e
  end

private

  def pusher
    @pusher ||= Pusher[@upload.pusher_key]
  end

end
