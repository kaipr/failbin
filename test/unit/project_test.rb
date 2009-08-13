require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  should_validate_presence_of :name
  
  should "be valid" do
    assert Factory(:project).valid?
  end
  
  should "set project_key on create" do
    project = Factory.build(:project)
    assert_nil project.project_key
    project.save
    assert_not_nil project.project_key
  end
  
end
