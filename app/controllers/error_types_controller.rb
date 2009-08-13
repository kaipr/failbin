class ErrorTypesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :find_error_type, :only => [:show, :update, :destroy]
  
  def show
    redirect_to project_error_type_errors_path(@project, @error_type)
  end
  
  def index
    #@error_types_open = ErrorType.find(:all, find_options_for_index("status <= #{ErrorType::STATUS_REOPEN}"))
    #@error_types_fixed = ErrorType.find(:all, find_options_for_index("status = #{ErrorType::STATUS_FIXED}"))
  end
  
  def open
    @error_types = ErrorType.paginate(:all, find_options_for_index("status <= #{ErrorType::STATUS_REOPEN}"))
    render :layout => false
  end
  
  def fixed
    @error_types = ErrorType.paginate(:all, find_options_for_index("status = #{ErrorType::STATUS_FIXED}"))
    render :layout => false
  end
  
  def update
    if @error_type.update_attributes :status => params[:status]
      flash[:notice] = "Successfully updated status for error type \"#{@error_type.name}\""
    else
      flash[:error] = "Failed to update status for error type \"#{@error_type.name}\""
    end
    redirect_to project_error_types_path(@project)
  end
    
  def destroy
    @error_type.destroy
    flash[:notice] = "Successfully destroyed errortype."
    redirect_to project_error_types_url(@project)
  end
  
protected
  
  def find_project # TODO: Refactor
    @project = current_user.projects.find(:first, :conditions => {:id => params[:project_id]})
    unless @project
      flash[:error] = "The project does not exist or you are not permitted to access it."
      redirect_back_or_default('/')
    end
  end
  
  def find_error_type
    @error_type = @project.error_types.find(:first, :conditions => {:id => params[:id]})
    unless @error_type
      flash[:error] = "The error_type does not exist or you are not permitted to access it."
      redirect_to project_error_types_path(@project)
    end
  end
  
  def find_options_for_index(condition = '')
    case params[:sort_by]
    when 'name'
      sort_by = "name"
    when 'location'
      sort_by = "controller, action"
    when 'error_count'
      sort_by = "error_count DESC"
    else
      sort_by = "errors.thrown_at DESC"
    end
    
    condition = " AND #{condition}" unless condition.empty?
    find_options = {:conditions => "project_id = #{@project.id}#{condition}", :order => sort_by, :include => :error_occurrences, :page => params[:page] ? params[:page].to_i : 1}
    
    if params[:search_string]
      search_string = params[:search_string].gsub(/\\/, '\&\&').gsub(/'/, "''")
      find_options[:conditions] += " AND backtrace LIKE '%#{search_string}%'"
    end
    
    find_options
  end
  
end
