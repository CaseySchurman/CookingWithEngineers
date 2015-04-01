################################################################################
#Author: Johnathan Leuthold
#Date: 11-25-2014
#Modifications: 12-1-2014 Chad Greene
#Description: The User model inherits from ActiveRecord which facilitates the 
#creation of the business object User, which is essentially a class whose 
#attributes are the columns derived from the plural database table 'users'. 
#ActiveRecord represents the persistence layer of the application.
################################################################################
#This model captures an individual 'User' object from the users table.
class User < ActiveRecord::Base
  
    #Relationships
  has_many :recipes, dependent: :destroy
  has_many :comments
  has_many :ratings
  has_many :active_follows, class_name: "Follow",
                            foreign_key: "follower_id",
                            dependent: :destroy
  has_many :passive_follows, class_name: "Follow",
                             foreign_key: "followed_id",
                             dependent: :destroy
  
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower
  
    #Accessible attributes outside of those permitted in controller
  attr_accessor :remember_token, :activation_token, :reset_token
  
    #Tells model to use BCrypt to create password digest
  has_secure_password
  
    #before action callbacks
  before_save :downcase_email
  before_create :create_activation_digest

    #Defines a regular expression for emails
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Za-z]{2,20}\z/i
  
    #Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }, 
                       length: 3..25
  validates :email, presence: true, uniqueness: {case_sensitive: false }, 
                    length: 6..255, format: EMAIL_REGEX
    ############################################################################
    # has_secure_password enforces password on creation.  allow_blank allows
    # blank password for updates
    ############################################################################
  validates :password, confirmation: true, length: 6..35, allow_blank: true
    
    ############################################################################
    # Only checks password confirmation on creation since helper method
    # verifies password_confirmation on updates
    ############################################################################
  validates :password_confirmation, presence: true, on: [:create]
  
  ##############################################################################
  # Opperation done within Users singleton
  ##############################################################################
  class << self
    ############################################################################
    # Same authentication algorithm that BCrypt uses to hash the password.  
    # Function will be used to hash reset and activation tokens
    #
    # Entry: token needs encrypting
    #
    #  Exit: attribute digest stored in database
    ############################################################################
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? 
             BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
    ############################################################################
    # Creates a url safe base 64 token
    #
    # Entry: none
    #
    #  Exit: instance token generated
    ############################################################################
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  
  ##############################################################################
  # Sets up remember digest in database that signed cookies will use to 
  # authenticate a remembered user
  #
  # Entry: none
  #
  #  Exit: remember digest set
  ##############################################################################
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  ##############################################################################
  # Forgets user credentials
  #
  # Entry: none
  #
  #  Exit: remember digest set to nil
  ##############################################################################
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  ##############################################################################
  # Takes in an attribute to test and a token.  The attribute correspondes to a
  # digest in the database.  The token should be a password for the hash.
  #
  # Entry: attribute is digest to look up
  #        token is password for digest
  #
  #  Exit: returns true if token is a password for digest
  ##############################################################################
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  ##############################################################################
  # Activates a user account
  #
  # Entry: none
  #
  #  Exit: user account activated
  ##############################################################################
  def activate
    update_attribute(:activated, true)
  end
  
  ##############################################################################
  # Sends an activation email to user
  #
  # Entry: none
  #
  #  Exit: Activation email sent to user
  ##############################################################################
  def send_activation_email
    UserMailer.account_activation(self).deliver
  end
  
  ##############################################################################
  # Sets up a reset digest for a forgotten password
  #
  # Entry: none
  #
  #  Exit: reset digest set
  ##############################################################################
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end
  
  ##############################################################################
  # Sends a password reset email to user
  #
  # Entry: none
  #
  #  Exit: Password reset email sent to user
  ##############################################################################
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end
  
  ##############################################################################
  # Allows a user to follow another user
  #
  # Entry: none
  #
  #  Exit: following user
  ##############################################################################
  def follow(other_user)
    active_follows.create(followed_id: other_user.id)
  end
  
  ##############################################################################
  # Allows a user to unfollow a user they are currently following
  #
  # Entry: none
  #
  #  Exit: user unfollowed
  ##############################################################################
  def unfollow(other_user)
    active_follows.find_by(followed_id: other_user.id).destroy
  end
  
  ##############################################################################
  # Determines if one user is following another
  #
  # Entry: other_user is a possible follow
  #
  #  Exit: returns true if user is following other_user
  ##############################################################################
  def following?(other_user)
    following.include?(other_user)
  end
  
  ##############################################################################
  # Sets up the password reset link timer.  Expired links are not valid
  #
  # Entry: none
  #
  #  Exit: Password reset link timer set
  ##############################################################################
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
#PRIVATE########################################################################
private
  
  ##############################################################################
  # Sets email to all lowercase 
  #
  # Entry: none
  #
  #  Exit: email lowercase
  ##############################################################################
  def downcase_email
    self.email = email.downcase
  end
  
  ##############################################################################
  # Creates the user activation digest at registration
  #
  # Entry: none
  #
  #  Exit: activation digest set
  ##############################################################################
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end

