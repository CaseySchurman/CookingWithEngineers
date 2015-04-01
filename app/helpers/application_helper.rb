module ApplicationHelper
  ##############################################################################
  # Defines the bahavior of the title bar for each page
  # If no title is provided for the page only the base title is shown
  # otherwise both the page title and base title are shown seperated by a |
  #
  # Entry: page title is provided by the view for each page
  #        base title is the site name
  #
  #  Exit: page title set
  ##############################################################################
  def full_title(page_title = '')
    base_title = "Cooking with Engineers"
    if(page_title.empty?)
        base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  ##############################################################################
  # Mainly used to simplify new and edit forms since they are basically the same
  # except for the protocol used to render the page.  This function uses the
  # calling controller to generate form string to render.
  #
  # Entry: controller is action controller making call
  #
  #  Exit: form for controller selcted
  ##############################################################################
  def get_form
    "#{controller.controller_name}/form"
  end
end
