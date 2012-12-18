require 'uri'

class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :uid, :user

  has_many :sessions, class_name: 'PlayerSession' do

    def current
      active.first_or_initialize
    end

    def current?
      active.exists?
    end

  end


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
