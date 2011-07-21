class BetaUser
  include MongoMapper::Document
  key :email
  timestamps!
end
