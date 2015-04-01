################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The MainPages controller is designated as the root of the site.
#Displays protected data and behavior for logged in users and generic 
#information for un-registered users.
################################################################################
class MainPagesController < ApplicationController
  
    #Ensure pages are avaliable to all users
  skip_before_action :logged_in_user
  
  ##############################################################################
  # Default home page for all users.  <No content currently>
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def home
    @page_title = "Home"
    if(logged_in?)
      @recipes = current_user.recipes.all
    end
  end

  ##############################################################################
  # FAQ/Help page.  <No content currently>
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def help
    @page_title = "Help"
  end
  
  ##############################################################################
  # About Team.  <No content currently>
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def about
    @page_title = "About"
  end
  
end
