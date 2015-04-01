################################################################################
#Author: Johnathan Leuthold
#Date: 11-26-2014
#Modifications: 12-12-2014(Chad Greend)
#Description: The Sessions controller class holds temporary user attributes 
#across multiple views with a session object.
################################################################################
class SessionsController < ApplicationController
  helper_method :getElevation
  skip_before_action :logged_in_user, only: [:new, :create]
  
  ##############################################################################
  # Builds new user session
  #
  # Entry: none
  #
  #  Exit: 
  ##############################################################################
  def new
  end
  
  ##############################################################################
  # Creates a semi permanent session that secure session used to pass data
  # between pages for authenticated users
  #
  # Entry: user not logged in
  #
  #  Exit: user authenticated and logged in
  ##############################################################################
  def create
      #find user
    @user = User.find_by(username: params[:session][:username])  
      #authenticate user
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in(@user)
          #if remember me box is checked create remember token/cookie
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        flash.alert = "Account not activated. Check email for activation link"
        redirect_to root_url
      end
    else
      flash.now.alert = "Invalid username/password combination"
      render 'new'
    end
  end
  
  public
  ##############################################################################
  # Gets the elvation of the current user according to their ip_address
  #
  # Entry: 
  #
  #  Exit: 
  ##############################################################################
  # def getElevation
  #   elevation_base_url = 'https://maps.googleapis.com/maps/api/elevation/json'
    
  #   geocoded_by :ip_address
  #   after_validation :geocode
    
  #   url = elevation_base_url + "?locations=" + :latitude.to_s + ',' + :longitude.to_s
  #   #flash.now.alert = url
  #   #response = simplejson.load(urllib.urlopen(url))
    
  #   #elevation = resultset(['elevation'])
  #   return 5
  # end
  
  ##############################################################################
  # Destroys the user session
  #
  # Entry: user may be logged in
  #
  #  Exit: session destroyed and user returned to root
  ##############################################################################
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end