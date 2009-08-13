class UserMailer < ActionMailer::Base

  def new_error_type_notification(error_type, user)
    recipients user.email
    from       "notifications@failbin.spiking.de"
    subject    "failbin: New error type in project #{error_type.project.name}: #{error_type.name}"
    body :error_type => error_type
  end
  
  def daily_summary(user, user_data)
    recipients user.email
    from       "notifications@failbin.spiking.de"
    subject    "failbin: Daily summary"
    body :user_data => user_data
  end

end
