module UsersHelper

  def link_to_pro(user)
    if signed_in?
      link_to('Pro', pro_account_user_path, class: 'pro')
    else
      content_tag(:span, 'Pro', class: 'pro')
    end
  end

end
