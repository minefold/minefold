require 'uri'

class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :uid, :user

  def username
    uid
  end

  def to_partial_path
    File.join('accounts', self.class.name.demodulize.underscore)
  end

  def linked?
    not new_record?
  end

end
