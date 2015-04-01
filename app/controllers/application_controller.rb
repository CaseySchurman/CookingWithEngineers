################################################################################
#Author: Johnathan Leuthold
#Date: 11-26-2014
#Modifications: 12-13-14(Chad Greene) 
#Description: The Application controller contains override methods to prevent 
#inappropriate views from being displayed to a user based on their current log 
#in state. It does this from the sessions controller under its before_action:
#callbacks, these filters call a method in the ApplicationController if certain 
#methods in the sessions controller fire as a means of validating whether that 
#method is appropriate.  The session helper is included for this purpose. Since
#all controllers inherit the properties of the Application controller, the 
#methods current_user and current_recipe can be used on all views to control
#view based logic.
################################################################################

class ApplicationController < ActionController::Base
  #protect from CRSF attacks
protect_from_forgery with: :exception
  
  # include Session logic
include SessionsHelper

  # Sets ActionMailer::Base
before_action :make_action_mailer_user_request_host_and_protocol

  #ensures the user is logged in to access protected content
before_action :logged_in_user, except: [:new, :show]  
  
  ##############################################################################
  # Saves the url request of a user that is not logged in.  Upon a successful
  # login the user is directed to the saved page request.
  #
  # Entry: none
  #
  #  Exit: If user is logged out current request stored and user directed to
  #        login page
  ##############################################################################
  def logged_in_user
    unless logged_in?
      store_location
      flash.alert = "Please log in"
      redirect_to login_url
    end
  end
  
  ##############################################################################
  # Callback for protected content.  Used for checking whether or not the
  # logged in user is an administrator.
  ##############################################################################
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  ##############################################################################
  # Sets all ActionMailers to use the same protocol and host that the processing
  # page used. Email links are sent with the same protocol the page is rendered
  # under.  i.e https rather than http when running ssl on app traffic. 
  ##############################################################################
  def make_action_mailer_user_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  ##############################################################################
  # Used for checking whether or not the logged in user owns an object 
  # or if user is an administrator within the views.
  ##############################################################################
  def correct_user(user)
      redirect_to(root_url) unless (admin || current_user?(user))
  end
end
