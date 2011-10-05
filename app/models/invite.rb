class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  CODE_LENGTH = 6

  belongs_to :world

  field :claimed, type: Boolean, default: false
  field :code,    type: String, default: -> {
    begin
      c = rand(36 ** CODE_LENGTH).to_s(36).rjust(CODE_LENGTH, '0').upcase
    end while User.where(code: c).exists?
    c
  }

  field :email,   type: String

  scope :unclaimed, where(claimed: false)

# VALIDATIONS

  validates_uniqueness_of :code

  def email=(str)
    super str.downcase.strip
  end

  def mail
    UserMailer.invite(id)
  end

end
