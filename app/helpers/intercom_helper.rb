module IntercomHelper

  def intercom_settings
    settings = {
      app_id: ENV['INTERCOM_APP_ID'],
      custom_data: {},
      widget: {
        activator: '#Intercom'
      }
    }

    if signed_in?
      settings.merge!(
        email: current_user.email,
        created_at: current_user.created_at.to_i
      )
      settings[:custom_data].merge!(
        "profile url" => user_url(current_user)
      )
    end

    settings
  end

  def intercom_script_tag
    js = "var intercomSettings = #{intercom_settings.to_json};".html_safe
    content_tag :script, js, id: 'IntercomSettingsScriptTag'
  end

end
