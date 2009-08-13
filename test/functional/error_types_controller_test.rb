require 'test_helper'

class ErrorTypesControllerTest < ActionController::TestCase
  context "user is logged in" do
    setup do
      @error_type = Factory(:error_type)
      Factory(:error, :error_type_id => @error_type.id)
      Factory(:error, :error_type_id => @error_type.id)
      @project = @error_type.project
      @project.users << Factory(:user)
      login_as @project.users.first
    end
    
    context "index action" do
      should "render index template" do
        get :index, :project_id => @project
        assert_response :success
        assert_template 'index'
      end
    end
  
    context "destroy action" do
      should "destroy model and redirect to index action" do
        delete :destroy, :id => @error_type, :project_id => @project
        assert_redirected_to project_error_types_url(assigns(:project))
        assert !ErrorType.exists?(@error_type)
      end
    end
  end
  
  context "user id not logged in" do
    should "redirect to sessions/new" do
      get :index
      assert_redirected_to new_session_path
    end
  end
  
end
