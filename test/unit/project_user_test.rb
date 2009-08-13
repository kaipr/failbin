require 'test_helper'

class ProjectUserTest < ActiveSupport::TestCase
  
  should_validate_presence_of :project_id, :user_id
  
  should "be valid" do
    assert Factory(:project_user).valid?
  end
  
end
