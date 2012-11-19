module Concerns::Authentication

  # Can't use ActiveSupport::Concern here because it includes ClassMethods before evaluating the block. Any class methods that are meant to override their Devise equivilant would be overridden.
  def self.included(base)
    base.class_eval do
      devise :database_authenticatable, :token_authenticatable, :omniauthable,
             :confirmable, :recoverable, :registerable, :rememberable, :trackable,
             :validatable, reconfirmable: true

      validates_uniqueness_of :facebook_uid, allow_nil: true

      # Everybody gets an authentication token for quick access from emails
      before_save :ensure_authentication_token

      attr_accessor :email_or_username
    end

    base.extend ClassMethods
  end


# --


  module ClassMethods

    # Lets users sign in with either their username or password
    def find_for_database_authentication(conditions)
      email_or_username = conditions.delete(:email_or_username)

      where(arel_table[:email].eq(email_or_username).or(
          arel_table[:username].eq(email_or_username))).first
    end

    def find_or_initialize_from_facebook(access_token)
      find_by_facebook_uid(access_token) || initialize_from_facebook(access_token)
    end

    # Finds any user that matches the auth details supplied by Facebook. The current_user is passed in as an optimisation so a second query doesn't have to be made.
    def find_for_facebook_oauth(auth, current_user = nil)
      if current_user && current_user.facebook_uid == auth['uid']
        current_user
      else
        find_by_facebook_uid(auth['uid'])
      end
    end

    def new_with_session(params, session)
      super.tap do |user|
        # Mixpanel
        if session['distinct_id'].present?
          user.distinct_id = session['distinct_id']
        end

        # Invitations
        if session['invitation_token'].present?
          invited_by = User.find_by_invitation_token(session['invitation_token'])

          if invited_by
            user.invited_by = invited_by
          end
        end

        # Facebook
        data = session['devise.facebook_data']
        if data and data['extra'] and data['extra']['raw_info']
          user.update_facebook_auth(data)
        end
      end
    end

    def extract_facebook_attrs(attrs)
      { username: attrs['username'],
        email: attrs['email'],
        first_name: attrs['first_name'],
        last_name:  attrs['last_name'],
        name: attrs['name'],
        locale: attrs['locale'],
        timezone: attrs['timezone'],
        gender: attrs['gender']
      }
    end

  end


# --


  def update_facebook_auth(auth)
    raw_attrs = auth['extra']['raw_info']

    # This is horrible and ugly and makes babies cry, but I'm not sure of a better way of doing it with ActiveRecord.
    self.class.extract_facebook_attrs(raw_attrs).each do |attr, val|
      previous_val = self.send(attr)
      (previous_val && previous_val.present?) || self.send("#{attr}=", val)
    end

    # The email we get back from Facebook is guarenteed to be verified so we can skip those users needing to confirm their email again.
    if self.email == raw_attrs['email'] && self.confirmed_at.nil?
      self.skip_confirmation!
    end
  end

end
