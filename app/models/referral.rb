class Referral
  include Mongoid::Document
  include Mongoid::Timestamps

  CODE_LENGTH = 6

  field :email,   type: String
  field :claimed, type: Boolean, default: false
  field :code,    type: String, default: -> {
    begin
      c = rand(36 ** CODE_LENGTH).to_s(36).rjust(CODE_LENGTH, '0').upcase
    end while User.where('referrals.code' => c).exists?
    c
  }

  embedded_in :creator, class_name: 'User'
  belongs_to  :user


# VALIDATIONS

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :code
  validates_uniqueness_of :user


  def email=(str)
    super str.downcase.strip
  end

  def to_param
    code
  end

end
