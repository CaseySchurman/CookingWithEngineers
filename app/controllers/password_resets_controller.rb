################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The PasswordReset controller allows a user to reset their
#password using their email and a validation token
################################################################################
class PasswordResetsController < ApplicationController
    
    #Looks up user from email provided by validation link
  before_action :get_user,         only: [:edit, :update]
    #Validates the token :id provided by the validation link 
  before_action :valid_user,       only: [:edit, :update]
    #Ensures the validation link has not expired
  before_action :check_expiration, only: [:edit, :update]
  
    #User does not need to be logged in to acccess pages
  skip_before_action :logged_in_user
  
  ##############################################################################
  # New password reset form
  #
  # Entry: none
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "Password Reset"
  end
  
  ##############################################################################
  # Creates new password reset from submitted email
  #
  # Entry: dirty form
  #
  #  Exit: If record found reset email sent to user, <password in db not reset>
  ##############################################################################
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash.alert = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now.alert = "Email address not found"
      render 'new'
    end
  end
  
  ##############################################################################
  # The reset link provided in the email is directed here
  #
  # Entry: :get_user with email from reset link
  #        :valid_user with id from reset link
  #        :check_expiration compare to sent time in db
  #
  #  Exit: none
  ##############################################################################
  def edit
    @page_title = "Update password"
  end
  
  ##############################################################################
  # Update password from reset link
  #
  # Entry: :get_user with email from reset link
  #        :valid_user with id from reset link
  #        :check_expiration compare to sent time in db
  #        dirty form
  #
  #  Exit: password updated in db with new entry from form
  ##############################################################################
  def update
    if both_passwords_blank?
      flash.now.alert = "Password/confirmation can't be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash.alert = "Password has been reset."
      redirect_to @user
    else
      flash.now.alert = "Form error"
      render 'edit'
    end
  end
  
#############################################################################
private
  ##############################################################################
  # Allows only permitted parameters to be submitted and used on the pages
  ##############################################################################
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  ##############################################################################
  # Ensures neither password on reset form is blank
  ##############################################################################
  def both_passwords_blank?
    params[:user][:password].blank? &&
    params[:user][:password_confirmation].blank?
  end

  ##############################################################################
  # Finds user in db by email provided in link
  ##############################################################################
  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  ##############################################################################
  # Validates that id in email link is a password for reset digest in the db
  # and that user account is activated.
  ##############################################################################
  def valid_user
    unless (@user && @user.activated? && 
           @user.authenticated?(:reset, params[:id]))
      if !@user.nil?  && !@user.activated?
        flash.alert = "Account not activated"
      else
        flash.alert = "Invalid password reset link"
      end
      redirect_to root_url
    end
  end
  
  ##############################################################################
  # Check that the link is not expired
  ##############################################################################
  def check_expiration
    if(@user.password_reset_expired?)
      flash.alert = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end

end
