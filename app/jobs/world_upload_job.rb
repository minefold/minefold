class WorldUploadJob < Job
  @queue = :low

  def initialize(world_upload_id)
    @upload = WorldUpload.find(world_upload_id)
  end

  def perform!
    logger.info "Downloading #{@upload.s3_key}"
    @upload.download!

    logger.info "Extracting #{@upload.uploaded_archive_path} to #{@upload.extraction_path}"
    @upload.extract!

    logger.info "Parsing seed from #{@upload.level_dat_path}"
    @upload.parse_seed!

    logger.info "Cleaning data"
    @upload.clean!

    logger.info "Building archive"
    @upload.build!

    logger.info "Uploading archive"
    @upload.upload!

    logger.info "Saving WorldUpload##{@upload.id}"
    @upload.save!

    pusher.trigger('success', @upload.to_json)

  rescue WorldUpload::InvalidUploadError => e
    pusher.trigger('error', e.message)

  rescue WorldUpload::UnreadableUploadError => e
    pusher.trigger('error', e.message)

  rescue => e
    pusher.trigger('error', 'Something horrible happened. Sorry!')

    raise e
  end

private

  def pusher
    @pusher ||= Pusher[@upload.pusher_key]
  end

end
