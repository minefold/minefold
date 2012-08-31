module UsersHelper

  def user_credits(user)
    { cr: user.cr,
      credit_threshold: 600,
      pro: user.pro?
    }
  end

  def link_to_pro(user)
    if signed_in?
      link_to('Pro', pro_account_path, class: 'pro')
    else
      content_tag(:span, 'Pro', class: 'pro')
    end
  end

end
