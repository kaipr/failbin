require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  
  context "as logged in user" do
    setup do
      @user = Factory(:user)
      login_as @user
      @project = Factory(:project)
      @project_user = Factory(:project_user, :user_id => @user.id, :project_id => @project.id)
      @foreign_project = Factory(:project)
    end
  
    context "index action" do
      should "render index template" do
        get :index
        assert_response :success
        assert_template 'index'
        assert_contains assigns(:projects), @project
      end
    end

    # TODO: Move to error_types_controller_test
    # context "show action" do
    #   should "render show template if project is assigned to user" do
    #     get :show, :id => @project
    #     assert_template 'show'
    #   end
    #   
    #   should "redirect to home if project is not assigned to user" do
    #     get :show, :id => @foreign_project
    #     assert_redirected_to '/'
    #   end
    # end
  
    context "new action" do
      should "render new template" do
        get :new
        assert_template 'new'
      end
    end
  
    context "create action" do
      should "render new template when model is invalid" do
        Project.any_instance.stubs(:valid?).returns(false)
        post :create
        assert_template 'new'
      end
    
      should "redirect when model is valid" do
        Project.any_instance.stubs(:valid?).returns(true)
        post :create
        assert_redirected_to project_error_types_path(assigns(:project))
      end
    end
  
    context "edit action" do
      should "render edit template" do
        get :edit, :id => @project
        assert_template 'edit'
      end
    end
  
    context "update action" do
      should "render edit template when model is invalid" do
        Project.any_instance.stubs(:valid?).returns(false)
        put :update, :id => @project
        assert_template 'edit'
      end
  
      should "redirect when model is valid" do
        Project.any_instance.stubs(:valid?).returns(true)
        put :update, :id => @project
        assert_redirected_to project_url(assigns(:project))
      end
    end
  
    context "destroy action" do
      should "destroy model and redirect to index action" do
        delete :destroy, :id => @project
        assert_redirected_to projects_url
        assert !Project.exists?(@project.id)
      end
    end
    
    context "user assignment" do
      setup do
        @user2 = Factory(:user)
      end
      
      should "add user to a project" do
        assert_difference "Project.find(#{@project.id}).users.count", 1 do
          post :add_user, :project_user => {:user_id => @user2.id}, :id => @project
        end
      end
      
      should "remove user from a project" do
        @project.users << @user2
        assert_difference "Project.find(#{@project.id}).users.count", -1 do
          delete :remove_user, :id => @project, :user_id => @user2.id
        end
      end
    end
    
  end
  
  context "as not logged in user index action" do
    should "redirect to login" do
      get :index
      assert_response :redirect
      assert_redirected_to new_session_path
    end
  end
  
end
