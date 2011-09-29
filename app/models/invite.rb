class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  CODE_LENGTH=16

  embedded_in :world

  belongs_to :from, class_name:'User'
  belongs_to :to, class_name:'User'
  field :email

  field :claimed, type: Boolean

  field :code, type: String, default: -> {
    code = nil
    begin
      code = self.class.random_code
    end while self.class.where(code: self.code).exists?
    code
  }

  validates_presence_of :code
  validates_presence_of :from

  scope :claimed, where(:receiver.ne => nil)

private

  def self.random_code(length=CODE_LENGTH)
    rand(36 ** length).to_s(36)
  end

end