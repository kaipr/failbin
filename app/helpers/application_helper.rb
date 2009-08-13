# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def wrap_text(text, col = 80)
    text.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/,
      "\\1\\3\n") 
  end
  
  def both_project_error_types_path(type, project, options)
    case type
    when 'open'
      open_project_error_types_path(project, options)
    when 'fixed'
      fixed_project_error_types_path(project, options)
    end
  end
end
