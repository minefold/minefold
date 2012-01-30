module NotificationsHelper
  def setting form, notification, text
    p current_user.notifications, current_user.notifications[notification.to_s]
    content = [
      form.check_box(notification, 
        checked: (current_user.notifications[notification.to_s] != "0")),
      form.label(notification, text)
    ].join.html_safe
    
    content_tag(:section, content)
  end
end