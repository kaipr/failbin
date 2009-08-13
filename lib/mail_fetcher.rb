require 'net/imap'

class MailFetcher
  
  def initialize
    @config = YAML.load(File.read("#{RAILS_ROOT}/config/mail_fetcher.yml"))
  end
  
  def fetch_mails
    self.connect unless @imap
    @imap.uid_search(["NOT", "DELETED"]).each do |uid|
      mail = TMail::Mail.parse(@imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822'])
      if process_mail(mail)
        @imap.uid_store(uid, "+FLAGS", [:Deleted]) # TODO: Does this move to trash? If not, do it!
      end
    end
  end
  
protected
  
  def connect
    @imap = Net::IMAP.new(@config[RAILS_ENV]['server'], @config[RAILS_ENV]['port'], @config[RAILS_ENV]['ssl'])
    @imap.login @config[RAILS_ENV]['username'], @config[RAILS_ENV]['password']
    @imap.select 'Inbox'
  end
  
  def process_mail(mail)
    project_key, environment = mail.subject.match(/[0-9a-z]{40}-[0-9a-z]*/).to_s.split '-'
    project = Project.find_by_project_key(project_key)
    return false if project.nil?
    environment = 'undefined' if environment.nil? || environment.empty?
    
    body = mail.body.split "\n"
    
    data = ExceptionNotificationParser.parse(body).merge({:project_key => project_key, :rails_environment => environment, :thrown_at => mail.date})
    
    error_type = ErrorType.find_or_create_by_mail_data(data, project)
    Error.create_by_mail_data(data, error_type)
    
    true # false = dont delete
  end
  
  
end