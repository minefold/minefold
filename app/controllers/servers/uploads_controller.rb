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

  def sign
    objectName = params[:s3_object_name]
    mimeType = params[:s3_object_type]
    expires = Time.now.to_i + 100 # PUT request to S3 must start within 100 seconds

    key = "minefold-development/#{objectName}"
    s3_url = "http://s3.amazonaws.com/"
    url = "#{s3_url}#{key}"

    amzHeaders = "x-amz-acl:public-read" # set the public read permission on the uploaded file
    stringToSign = "PUT\n\n#{mimeType}\n#{expires}\n#{amzHeaders}\n/#{key}";
      sig = CGI::escape(
        Base64.strict_encode64(
          OpenSSL::HMAC.digest('sha1', ENV['AWS_SECRET_KEY'], stringToSign)))

      {
        signed_request: CGI::escape("#{url}?AWSAccessKeyId=#{ENV['AWS_ACCESS_KEY']}&Expires=#{expires}&Signature=#{sig}"),
        url: url
      }.to_json
  end

end
