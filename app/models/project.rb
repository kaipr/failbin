class Project < ActiveRecord::Base

  has_many :error_types, :dependent => :destroy
  has_many :project_users, :dependent => :destroy
  has_many :users, :through => :project_users

  validates_presence_of :name
  
  before_create :set_project_key
  
  def error_types_count
    error_types.count
  end
  
  def error_count
    sum = 0
    error_types.each {|et| sum += et.error_count }
    sum
  end
  
  private
  
  def set_project_key
    self.project_key = Digest::SHA1.hexdigest("#{rand(10000)}--#{SECRET_STRING}--#{self.name}--#{Time.now}")
    set_project_key if Project.find_by_project_key(self.project_key)
  end

end
