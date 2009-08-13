require 'json'

class Error < ActiveRecord::Base

  belongs_to :error_type, :counter_cache => :error_count

  validates_presence_of :error_type_id, :rails_environment, :thrown_at
  
  serialize :params
  serialize :session
  serialize :environment
  
  default_scope :order => 'thrown_at DESC'
  
  def self.per_page
    20
  end
  
  def self.create_by_mail_data(data, error_type)
    # rails environment is not availble in the exception_notifier mail!
    rails_environment = data[:rails_environment]
    request_type = data[:environment]['REQUEST_METHOD']
    url = data[:request]['URL']
    parameters = data[:request]['parameters']
    #params_hash = parameters.nil? || parameters == 'nil' ? {} : JSON.parse(parameters)
    session_data = data[:session]['data']
    #session_hash = session_data.nil? || session_data == 'nil' ? {} : JSON.parse(session_data)
    environment_hash = data[:environment]
    thrown_at = data[:thrown_at]
    self.create(:error_type_id => error_type.id, :rails_environment => rails_environment, :request_type => request_type, :url => url, :params => parameters, :session => session_data, :environment => environment_hash, :thrown_at => thrown_at)
  end

end
