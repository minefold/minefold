class WorldUpload
  include Mongoid::Document
  include Mongoid::Timestamps

  field :s3_key, type: String
  field :filename, type: String
  field :process_result, type: String
  
  belongs_to :uploader, class_name: 'User'
  belongs_to :world
end