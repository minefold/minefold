module IntercomHelper

  def intercom_settings
    settings = {
      app_id: '8oc9zbvo',
      custom_data: {},
      widget: {
        label: 'Support'
      }
    }
    if signed_in?
      settings.merge!(
        email: current_user.email,
        created_at: current_user.created_at.to_i,
        user_hash: Digest::SHA1.hexdigest('kczzht6c' + current_user.email)
      )
      settings[:custom_data].merge! current_user.tracking_data
    end

    settings
  end

  def intercom_script_tag
    js = "intercomSettings = #{intercom_settings.to_json};".html_safe
    content_tag :script, js, id: 'IntercomSettingsScriptTag'
  end

end
