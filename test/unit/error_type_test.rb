require 'test_helper'

class ErrorTypeTest < ActiveSupport::TestCase
  
  should_have_many :error_occurrences
  
  should_validate_presence_of :name, :backtrace, :project_id
  
  should "be valid" do
    assert Factory(:error_type).valid?
  end
  
  should "set backtrace_hash before save" do
    error_type = Factory.build(:error_type)
    assert_nil error_type.backtrace_hash
    error_type.save
    assert_not_nil error_type.backtrace_hash
  end
end
