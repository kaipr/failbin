class DailySummary
  
  def send_daily_summaries
    get_all_project_data
    User.all(:include => :project_users).each do |user|
      user_data = []
      user.project_users.each do |project_user|
        if project_user.receive_daily_summary?
          user_data << @data[project_user.project_id]
        end
      end
      UserMailer.deliver_daily_summary(user, user_data) unless user_data.empty?
    end
  end
  
  def get_all_project_data
    @data = {}
    Project.all.each do |project|
      @data[project.id] = {:project => project, :active_error_types => project.error_types.active}
    end
  end
  
end