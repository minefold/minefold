class WorldUpload
  include Mongoid::Document
  include Mongoid::Timestamps

  # the original file uploaded
  field :s3_key, type: String
  field :filename, type: String

  # the result of processing into a world data file
  field :process_result, type: String

  # the new world data file ready for use
  field :world_data_file, type: String
  
  belongs_to :uploader, class_name: 'User'
  belongs_to :world
end