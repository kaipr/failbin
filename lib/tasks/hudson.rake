module HudsonCompatibility

 # This hack is needed because db:test:purge implementation for MySQL drops the test database, invalidating
 # the existing connection. A solution is to reconnect again.
 def self.reconnect
   require 'active_record'
   configurations = ActiveRecord::Base.configurations
   if configurations and configurations.has_key?("test") and configurations["test"]["adapter"] == 'mysql'
     ActiveRecord::Base.establish_connection(:test)
   end
 end
 
end

task "hudson" do
  begin
    gem 'ci_reporter'
  rescue
    $: << File.dirname(__FILE__) + "/../lib"
  end

  require 'ci/reporter/rake/rspec'
  require 'ci/reporter/rake/test_unit'
  RAILS_ENV = 'test'
  Rake::Task['db:test:purge'].invoke
  HudsonCompatibility::reconnect
  Rake::Task['db:migrate'].invoke

  if Rake.application.lookup('spec')
    Rake::Task['ci:setup:rspec'].invoke
    Rake::Task['spec'].invoke  
  else
    Rake::Task['ci:setup:testunit'].invoke
    Rake::Task['test'].invoke
  end

end
