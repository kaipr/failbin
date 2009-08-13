require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase

  should "allow signup" do
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  should "require login on signup" do
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end
  
  should "require name on signup" do
    assert_no_difference 'User.count' do
      create_user(:name => nil)
      assert assigns(:user).errors.on(:name)
      assert_response :success
    end
  end

  should "require password on signup" do
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  should "require password confirmation on signup" do
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  should "require email on signup" do
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end
  

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :name => 'quireuser', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
