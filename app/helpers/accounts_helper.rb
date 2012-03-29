module AccountsHelper

  def link_to_user(user, options={})
    content_tag(:span, class: 'username') {
      link_to(user.username, user_path(user), options)
    } + (pro_link(user) if user.pro?)
  end

  def pro_link(user)
    if signed_in?
      link_to('Pro', pro_account_user_path, class: 'pro')
    else
      content_tag(:span, 'Pro', class: 'pro')
    end
  end

end
