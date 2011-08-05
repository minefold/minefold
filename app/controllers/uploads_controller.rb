require 'base64'

class UploadsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  include S3SwfUpload::Signature

  def index
    bucket = ['minefold', Rails.env, 'import'].join('.')
    acl    = 'public-read'
    expiration_date = 1.hour.from_now.utc

    policy = encode({
      expiration: expiration_date,
      conditions: [
          {bucket: bucket},
          {key: params[:key]},
          {acl: acl},
          {'Content-Type' => params[:content_type]},
          {'Content-Disposition' => 'attachment'},
          ['starts-with', '$Filename', ''],
          ['eq', '$success_action_status', '201']
        ]
      }.to_json)

    signature = encode(
      OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'),
                           ENV['S3_SECRET'], policy))

    respond_to do |format|
      format.xml {
        render :xml => {
          :policy          => policy,
          :signature       => signature,
          :bucket          => bucket,
          :accesskeyid     => ENV['S3_KEY'],
          :acl             => acl,
          :expirationdate  => expiration_date,
          :https           => true,
          :errorMessage    => ''
        }
      }
    end
  end

protected

  def encode(str)
    Base64.encode64(str).gsub(/\n|\r/, '')
  end

end
