class LegacyWorldMailer < ActionMailer::Base
  include Resque::Mailer
  include WorldHelper

  helper :world

  layout 'mailer'


end
