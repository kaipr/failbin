class ErrorsController < ApplicationController
  before_filter :login_required
  before_filter :init_context
  
  def index
    @error = @error_type.error_occurrences.first
    render :template => 'errors/show'
  end
  
  def show
    @error = @error_type.error_occurrences.find(params[:id])
  end
  
protected
  
  def init_context
    @project = current_user.projects.find params[:project_id]
    @error_type = @project.error_types.find params[:error_type_id]
    @errors = @error_type.error_occurrences.paginate :page => params[:page] ? params[:page].to_i : 1
  end
  
end
