require 'openssl'
require 'digest/sha1'
require 'base64'
require 'json'

class S3UploadPolicy

  attr_reader :bucket, :expires, :secret_key, :access_key_id, :acl

  attr_accessor :key, :content_type

  def initialize(access_key_id, secret_key, bucket, opts={})
    @access_key_id = access_key_id
    @secret_key = secret_key
    @bucket = bucket
    @acl = opts[:acl] || 'public-read'

    # default to one hour from now
    @expires = opts[:expires] || (Time.now + 3600)
  end

  def to_hash
    { s3: {
        accessKeyId: access_key_id,
        acl: acl,
        bucket: bucket,
        contentType: content_type,
        expires: expiration_time,
        key: key,
        secure: false,
        signature: signature,
        policy: policy
      }
    }
  end

  def expiration_time
    @expires.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
  end

  def policy
    @policy ||= Base64.encode64({
      'expiration' => expiration_time,
      'conditions' => [
        {'bucket' => bucket},
        {'acl' => acl},
        {'key' => @key},
        {'Content-Type' => @content_type},
        ['starts-with', '$Filename', ''],
        ['eq', '$success_action_status', '201']
      ]
    }.to_json)
  end

  def signature
    [OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret_key, policy)].pack("m").strip
  end

end
