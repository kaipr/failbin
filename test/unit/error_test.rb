require 'test_helper'

class ErrorTest < ActiveSupport::TestCase
  
  should_belong_to :error_type
  
  should_validate_presence_of :error_type_id, :rails_environment, :thrown_at
  
  should "be valid" do
    assert Factory(:error).valid?
  end
  
  context 'serialization' do
    
    should 'serialize params' do
      hash = Factory.next(:hash)
      error = Factory(:error, :params => hash)
      error.reload
      assert_equal hash, error.params
    end
    
    should 'serialize session' do
      hash = Factory.next(:hash)
      error = Factory(:error, :session => hash)
      error.reload
      assert_equal hash, error.session
    end
    
    should 'serialize environment' do
      hash = Factory.next(:hash)
      error = Factory(:error, :environment => hash)
      error.reload
      assert_equal hash, error.environment
    end
    
  end
  
end
