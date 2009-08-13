require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  
  context "user is logged in" do
    setup do
      @user = Factory(:user)
      @project = Factory(:project, :users => [@user])
      @error_type = Factory(:error_type, :project => @project)
      @error = Factory(:error, :error_type => @error_type)
      login_as @user
    end
    
    context "index action" do
      should "render index template" do
        get :index, :project_id => @project, :error_type_id => @error_type
        assert_response :success
        assert_template 'errors/show'
        assert_contains assigns(:errors), @error
      end
    end
  
    context "show action" do
      should "render show template" do
        get :show, :id => @error, :project_id => @project, :error_type_id => @error_type
        assert_response :success
        assert_template 'show'
        assert_equal @error, assigns(:error)
      end
    end
  end
  
end
