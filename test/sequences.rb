Factory.sequence :name do |n|
  "name_#{n}"
end

Factory.sequence :login do |n|
  "login_#{n}"
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

# TODO: More realistic
Factory.sequence :backtrace do |n|
  "backtrace_#{n}"
end

Factory.sequence :error_type_id do |n|
  n % 5 == 1 ? Factory(:error_type).id : ErrorType.last.id
end

Factory.sequence :project_id do |n|
  n % 5 == 1 ? Factory(:project).id : Project.last.id
end

Factory.sequence :rails_environment do |n|
  n % 3 == 0 ? 'development' : 'production'
end

Factory.sequence :thrown_at do |n|
  (Time.now - 60.minutes) + n.minutes
end

Factory.sequence :hash do |n|
  {'something' => "something_#{n}", 'others' => "others_#{n}"}
end

Factory.sequence :url do |n|
  "http://www.example#{n}.com"
end