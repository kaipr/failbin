class ProjectsController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project, :only => [:show, :update_notifications, :edit, :add_user, :remove_user, :update, :destroy]
  before_filter :find_current_project_user, :only => [:edit, :update, :update_notifications]
  before_filter :init_project_user_assignment, :only => [:edit, :update]
  
  def index
    @projects = current_user.projects
  end
  
  def show
    redirect_to edit_project_path(@project)
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    if @project.save
      ProjectUser.create(:project_id => @project.id, :user_id => current_user.id)
      flash[:notice] = "Successfully created project."
      redirect_to project_error_types_path(@project)
    else
      render :action => 'new'
    end
  end
  
  def update_notifications
    if @project_user.update_attributes(
        :receive_new_error_type_notification => params[:project_user][:receive_new_error_type_notification],
        :receive_daily_summary => params[:project_user][:receive_daily_summary]
      )
      flash[:notice] = 'Successfully updated your notification options.'
      redirect_to project_path(@project)
    else
      render :action => 'edit'
    end
  end
  
  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = "Successfully updated project."
      redirect_to @project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project.destroy
    flash[:notice] = "Successfully destroyed project."
    redirect_to projects_url
  end
  
  def add_user
    @project_user = ProjectUser.new(params[:project_user].merge({:project_id => @project.id}))
    if @project_user.save
      flash[:notice] = "Successfully added user #{@project_user.user.name} to project #{@project.name}."
      redirect_to edit_project_path(@project)
    else
      render :action => 'edit'
    end
  end
  
  def remove_user
    project_user = @project.project_users.find(:first, :conditions => {:user_id => params[:user_id]})
    user = project_user.user
    project_user.destroy
    flash[:notice] = "Successfully removed user #{user.name} from project #{@project.name}"
    redirect_to edit_project_path(@project)
  end
  
protected

  def find_project # TODO: Refactor
    @project = current_user.projects.find(:first, :conditions => {:id => params[:id]})
    unless @project
      flash[:error] = "The project does not exist or you are not permitted to access it."
      redirect_back_or_default('/')
    end
  end
  
  def find_current_project_user
    @project_user = current_user.project_users.find(:first, :conditions => {:project_id => @project})
  end
  
  def init_project_user_assignment
    @new_project_user = ProjectUser.new
    @user_select = (User.all - @project.users).collect {|u| [u.name, u.id] }
  end

end
