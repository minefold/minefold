class Servers::UploadsController < ApplicationController

  prepend_before_filter :authenticate_user!

# --

  expose :server

# --

  def create
    upload = WorldUpload.create s3_key: params[:key],
                                filename: params[:name],
                                user: current_user

    Resque.enqueue WorldUploadJob, upload.id
    render json: { id: upload.id }
  end

  def policy
    @policy = S3UploadPolicy.new ENV['AWS_ACCESS_KEY'],
                                 ENV['AWS_SECRET_KEY'],
                                 ENV['S3_BUCKET']

    @policy.key = params[:key]
    @policy.content_type = params[:contentType]

    render layout: false
  end

end
