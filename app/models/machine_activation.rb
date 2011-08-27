# Tracks the process of placing a machine under PwnPet's control.
class MachineActivation < ActiveRecord::Base
  # The machine whose activation is tracked by this record.
  belongs_to :machine, :inverse_of => :activation
  validates :machine, :presence => true
  validates :machine_id, :uniqueness => true
  
  # Reset the password of the user account used to take control of the machine?
  validates :password_reset, :inclusion => [true, false]
  
  # If set, indicates when the machine got under PwnPet's control.
  validates :completed_at, :timeliness => { :type => :datetime,
                                            :allow_nil => true }

  # True if PwnPet gained control of this machine. 
  def completed?
    !!completed_at
  end
  
  # Makes a valiant attempt to take over the machine.
  #
  # This method resumes where it left off whenever possible.
  def attempt
    raise "Machine already activated" if completed?
    
    credentials = machine.ssh_credentials
    non_su_credential = credentials.select(&:needs_sudo).first
    su_credential = credentials.reject(&:needs_sudo).first
    non_su_credential ||= su_credential
    
    shell = nil
    
    begin
      # Learn about the machine's platform.
      unless machine.kernel_info
        return unless shell ||= machine.ssh non_su_credential
        kernel_info = machine.build_kernel_info
        kernel_info.update_from_shell shell
        return unless kernel_info.save
      end
      
      # Create and activate a superuser ssh credential.
      unless su_credential.healthy?
        return unless shell ||= machine.ssh non_su_credential
        su_credential ||= machine.ssh_credentials.build :username => 'root'
        su_credential.new_key!
        return unless su_credential.save
        su_credential.install shell
      end

      if password_reset && non_su_credential != su_credential
      end
      
      completed_at = Time.now
      save!
    ensure
      shell.close if shell
    end
    true
  end
end
