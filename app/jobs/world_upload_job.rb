class WorldUploadJob < Job
  @queue = :low

  def initialize(world_upload_id)
    @upload = WorldUpload.find(world_upload_id)
  end

  def perform!
    pusher.trigger('update', 'downloading file')
    logger.info "Downloading #{@upload.s3_key}"
    @upload.download!

    pusher.trigger('update', 'extracting archive')
    logger.info "Extracting #{@upload.uploaded_archive_path} to #{@upload.extraction_path}"
    @upload.extract!

    pusher.trigger('update', 'parsing seed')
    logger.info "Parsing seed from #{@upload.level_dat_path}"
    @upload.parse_seed!

    pusher.trigger('update', 'cleaning data')
    logger.info "Cleaning data"
    @upload.clean!

    pusher.trigger('update', 'rebuilding archive')
    logger.info "Building archive"
    @upload.build!

    pusher.trigger('update', 'uploading archive')
    logger.info "Uploading archive"
    @upload.upload!

    pusher.trigger('update', 'saving metadata')
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
