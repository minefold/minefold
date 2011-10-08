class UploadsController < ApplicationController
  prepend_before_filter :authenticate_user!

  def new
  end

  def create
    upload = WorldUpload.create s3_key:params[:key],
                              filename:params[:name],
                              uploader:current_user

    Resque.enqueue ImportWorldJob, upload.id
    render json: { id:upload.id }
  end

  def policy
    @policy = S3UploadPolicy.new ENV['S3_KEY'],
                                 ENV['S3_SECRET'],
                                 "minefold.#{Rails.env}.worlds.uploads"

    @policy.key = params[:key]
    @policy.content_type = params[:contentType]

    render layout:false
  end

end
