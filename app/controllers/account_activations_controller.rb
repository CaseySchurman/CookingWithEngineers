################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The Account Activations controller implements one method that
#accepts as parameters and email and id.  The user is looked up by email address
#the id is the activation token generated at registration.  The token is used
#to authenticate against activation digest stored in the users table.
################################################################################

class AccountActivationsController < ApplicationController
  
    #User does not need to be logged in to access pages
  skip_before_action :logged_in_user
  
  ##############################################################################
  # After a user registers with the site an activation email link is sent to
  # the users email address.  The activation link directs the user to the this
  # function for processing.
  #
  # Entry: :email is users email
  #        :id is activation token
  #
  #  Exit: user account activated and user logged in
  #        or user direceted to root page
  ##############################################################################
  def edit
      #defines user as record found by email address
    user = User.find_by(email: params[:email])
      #ensures that user is found in database, user is not activated, and users
      #token can be used as a password for the activation_digest field
    if(user && !user.activated? && user.authenticated?(:activation, params[:id]))
      user.activate
      log_in user
      flash.alert = "Account activated"
      redirect_to user
    else
      flash.alert = "Invalid activation link"
      redirect_to root_url
    end
  end
  
end
