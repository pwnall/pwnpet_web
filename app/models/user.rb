# An user account.
class User < ActiveRecord::Base
  include AuthpwnRails::UserModel

  # True if the given user can edit this user account.
  def can_edit?(user)
    self == user
  end
  
  # True if the given user can see this user account.
  def can_read?(user)
    self == user
  end
  
  # True if the given user can list the user account database.
  def self.can_list_users?(user)
    false
  end

  # Add your extensions to the User class here.
  
  # Machines managed by the user.
  has_many :machines, :inverse_of => :user
end
