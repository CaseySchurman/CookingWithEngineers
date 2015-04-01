class UserMailer < ActionMailer::Base
  default from: "no-reply@vast-stream-5760.herokuapp.com"
  ##############################################################################
  # Generates an activation email link that will be used to activate the users
  # account after registration.
  #
  # Entry: user is instance of user object being registered
  #
  #  Exit: activation email generated and sent to users email
  ##############################################################################
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  ##############################################################################
  # Generates a password reset email link that will allow a user to change
  # their password if they have forgotten their current login credentials
  #
  # Entry: user is instance of user object being reset
  #
  #  Exit: reset email generated and setn to users email
  ##############################################################################
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
