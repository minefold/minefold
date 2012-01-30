module NotificationsHelper
  def setting form, notification, text
    content = [
      form.check_box(
        notification, 
        checked: current_user.notify?(notification)),
      form.label(notification, text)
    ].join.html_safe
    
    content_tag(:section, content)
  end
end