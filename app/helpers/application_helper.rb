# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	## Generate the page title
	def title(new_title)
  	content_tag('h2', new_title, :class => 'page_title') if new_title
  end

	## Generate the MENU html
  def layout_link_to(link_text, path)
    curl = url_for(:controller => request.path_parameters['controller'],
                          :action => request.path_parameters['action'])
    html = ''
    options = path == curl ? {:class => 'current'} : {}
    html << content_tag("li", link_to(link_text, path, options))
  end

end
