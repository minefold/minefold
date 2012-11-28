class MixpanelObserver < ActiveRecord::Observer
  observe :user

  def after_create(user)
    Mixpanel.async_track '$signup', distinct_id: user.distinct_id,
                                    time: user.created_at.to_i,
                                    ip: user.current_sign_in_ip
  end

end
