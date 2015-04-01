module SessionsHelper
  
  ##############################################################################
  # Allows a user to log in by setting the session[:user_id]
  #
  # Entry: user the user hash to log in
  #
  #  Exit: session[:user_id] set
  ##############################################################################  
  def log_in(user)
    session[:user_id] = user.id
  end
  
  ##############################################################################
  # Determines if the current user is logged in
  #
  # Entry: none
  #
  #  Exit: returns true if current user not nil
  ##############################################################################
  def logged_in?
    !current_user.nil?
  end
  
  ##############################################################################
  # Sets up the instance variable @current_user.  To minimize queries
  # performed on the database the current_user_id is checked against the 
  # session[:user_id] to determine if the variable has been set previously.
  #
  # Alternately if the user has a valid cookie from a previous login it
  # will be used to authenticate the user into the system.
  #
  # Entry: none
  #
  #  Exit: @current_user instance variable set
  ##############################################################################
  def current_user
      #If session[:user_id] is present user_id set to session[:user_id]
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      #If cookies[:user_id] is present user_id set to cookies[:user_id]
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if (user && user.authenticated?(:remember, cookies[:remember_token]))
        log_in user
        @current_user = user
      end
    end
  end
  
  ##############################################################################
  # Sets up an instance variable for @current_recipe.
  #
  # Entry: @current_user not nil
  #
  #  Exit: @current_recipe instance variable set
  ##############################################################################
  def current_recipe
    if(recipe_id = session[:recipe_id])
      @current_recipe ||= Recipe.find_by(id: recipe_id)
    end
  end
  
  ##############################################################################
  # Determines if the current user matches another user
  #
  # Entry: user is another user object
  #
  #  Exit: returns true if user equals current_user
  ##############################################################################
  def current_user?(user)
    user == current_user
  end
  
  ##############################################################################
  # Determines if the current user is an administrator
  #
  # Entry: none
  #
  #  Exit: returns true if current_user is admin
  ##############################################################################
  def admin
    if(session[:user_id])
      current_user.admin?
    end
  end
  
  ##############################################################################
  # Logs a user out of the application
  #
  # Entry: @current_user not nil
  #
  #  Exit: users session deleted
  ##############################################################################
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  ##############################################################################
  # Sets up signed cookies in the users browser that will be used to 
  # authenticate the users during future visits if the selected remember me 
  # at login
  #
  # Entry: user loggin in
  #
  #  Exit: browser cookies set
  ##############################################################################
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  ##############################################################################
  # Removes signed cookies from the users browser
  #
  # Entry: user logging in/out
  #
  #  Exit: user credentials removed from session
  ##############################################################################
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  ##############################################################################
  # Enhancement to redirect_to that allows sending to a default path or to a
  # path held in the session variable
  #
  # Entry: session[:forwarding_url] may be set to specific location
  #
  #  Exit: user directed to page or default
  ##############################################################################
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  ##############################################################################
  # Creates a forwarding url location in the session variable
  #
  # Entry: none
  #
  #  Exit: forwarding url set
  ##############################################################################
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
end
