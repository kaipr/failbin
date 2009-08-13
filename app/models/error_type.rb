class ErrorType < ActiveRecord::Base
  
  STATUS_OPEN = 1
  STATUS_REOPEN = 2
  STATUS_FIXED = 4
  
  belongs_to :project
  has_many :error_occurrences, :class_name => 'Error', :dependent => :destroy
  
  validates_presence_of :name, :backtrace, :project_id
  
  before_create :set_backtrace_hash
  
  named_scope :active, :include => :error_occurrences, :conditions => ['errors.thrown_at > ?', Time.now-24.hours], :group => 'error_types.id'
  
  def self.per_page
    20
  end
  
  def open?
    self.status == STATUS_OPEN || self.status == STATUS_REOPEN
  end
  
  def new?
    self.status == STATUS_OPEN
  end
  
  def reopen?
    self.status == STATUS_REOPEN
  end
  
  def fixed?
    self.status == STATUS_FIXED
  end
  
  def first_occurrence
    error_occurrences.last.thrown_at
  end
  
  def last_occurrence
    error_occurrences.first.thrown_at
  end
  
  def self.find_or_create_by_mail_data(data, project)
    name = data[:main][:exception_name]
    controller = data[:main][:controller]
    action = data[:main][:action]
    file, line, where = data[:main][:first_line].split ':'
    backtrace = data[:backtrace]
    backtrace_hash = Digest::MD5.hexdigest(data[:backtrace])
    
    unless error_type = self.find(:first, :conditions => {:project_id => project.id, :backtrace_hash => backtrace_hash, :name => name, :controller => controller, :action => action, :file => file, :line => line})
      error_type = ErrorType.new(:project_id => project.id, :name => name, :controller => controller, :action => action, :file => file, :line => line, :backtrace => backtrace)
      error_type.save
      notify_users_about_new_error_type(error_type)
    else 
      if error_type.fixed?
        error_type.update_attributes :status => ErrorType::STATUS_REOPEN
      end
    end
    error_type
  end
  
  def self.notify_users_about_new_error_type(error_type)
    error_type.project.project_users.each do |project_user|
      next unless project_user.receive_new_error_type_notification?
      UserMailer.deliver_new_error_type_notification(error_type, project_user.user)
    end
  end
  
protected
  
  def set_backtrace_hash
    self.backtrace_hash = Digest::MD5.hexdigest(self.backtrace)
  end
  
end
