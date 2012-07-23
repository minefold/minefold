module IntercomHelper

  def intercom_settings
    settings = {
      app_id: '8oc9zbvo',
      widget: {
        label: 'Support'
      }
    }

    if signed_in?
      settings[:email] = current_user.email
      settings[:name] = current_user.name,
      settings[:created_at] = current_user.created_at.to_i
      settings[:user_hash] = Digest::SHA1.hexdigest('kczzht6c' + current_user.email)

      settings[:custom_data] = {
        'beta?' => current_user.beta?,
        'created worlds' => current_user.created_worlds.count,
        'credits' => current_user.credits,
        'facebook?' => current_user.facebook_linked?,
        'minutes played' => current_user.minutes_played,
        'max world players' => current_user.world_player_counts.max,
        'member worlds' => current_user.worlds.count,
        'pro?' => current_user.pro?,
        'profile' => player_url(current_user.minecraft_player),
        'username' => current_user.username,
        'verify host' => current_user.verification_host,
        'verified?' => current_user.verified?,
      }
    end

    settings
  end

  def intercom_script_tag
    js = "var intercomSettings = #{intercom_settings.to_json};".html_safe
    content_tag :script, js, id: 'IntercomSettingsScriptTag'
  end

end
