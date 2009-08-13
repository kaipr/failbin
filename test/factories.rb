require File.expand_path(File.dirname(__FILE__) + "/sequences")

Factory.define :user do |f|
  f.login { Factory.next(:login) }
  f.name { Factory.next(:name) }
  f.email { Factory.next(:email) }
  f.password 'password'
  f.password_confirmation 'password'
end

Factory.define :project do |f|
  f.name { Factory.next(:name) }
  f.url { Factory.next(:url) }
end

Factory.define :project_user do |f|
  f.association :project
  f.association :user
end

Factory.define :error_type do |f|
  f.name { Factory.next(:name) }
  f.backtrace { Factory.next(:backtrace) }
  f.association :project
end

Factory.define :error do |f|
  f.association :error_type
  f.rails_environment { Factory.next(:rails_environment) }
  f.thrown_at { Factory.next(:thrown_at) }
  f.params { Factory.next(:hash) }
  f.session { Factory.next(:hash) }
  f.environment { Factory.next(:hash) }
end
