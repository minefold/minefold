module IntercomHelper
  
  def intercom_activator(selector)
    @intercom_activator = selector
  end
  
  def intercom_settings
    settings = { app_id: ENV['INTERCOM'] }
    
    if @intercom_activator
      settings[:widget] = { activator: @intercom_activator }
    end
    
    if signed_in?
      settings[:email] = current_user.email
      settings[:name] = current_user.name || current_user.username
      settings[:created_at] = current_user.created_at.to_i
      settings[:user_hash] = Digest::SHA1.hexdigest('kczzht6c' + current_user.email)

      settings[:custom_data] = {
        'id' => current_user.id,
        'credits' => current_user.credits,
        'username' => current_user.username,
      }
    end

    settings
  end

  def intercom_script_tag
    js = "var intercomSettings = #{intercom_settings.to_json};".html_safe
    content_tag :script, js, id: 'IntercomSettingsScriptTag'
  end

end
