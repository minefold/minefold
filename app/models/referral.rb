class Referral
  include Mongoid::Document

  # CODE_LENGTH = 6
  #
  # key :email, required: true, unique: true
  # key :code,  required: true, unique: true
  # key :claimed, default: false
  # key :creator_id, ObjectId
  # belongs_to :creator, class: User
  #
  # belongs_to :user
  #
  # timestamps!
  #
  # ensure_index :email, unique: true
  # ensure_index :code, unique: true
  #
  #
  # scope :claimed,   :claimed => true
  # scope :unclaimed, :claimed => false
  #
  #
  # # Normalize email
  # before_validation on: :create do
  #   email.try(:downcase!).try(:strip!)
  # end
  #
  # # Generate code
  # before_validation on: :create do
  #   begin
  #     self.code = rand(36 ** CODE_LENGTH).to_s(36)
  #   end while self.class.exist?(code: code)
  # end
  #
  # # Check user isn't already a member
  # validate on: :create do
  #   errors.add(:email, 'Is already a user') if User.exist?(email: email)
  # end
  #
  # def to_param
  #   code
  # end
end
