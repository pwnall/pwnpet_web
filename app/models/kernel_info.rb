# Identifies the kernel running on a computer.
class KernelInfo < ActiveRecord::Base
  # The machine whose kernel is tracked.
  belongs_to :machine
  validates :machine, :presence => true
  validates :machine_id, :uniqueness => true
  
  # Kernel name, e.g. Linux
  validates :name, :length => 0..64, :presence => true
  
  # Version of kernel package, e.g. 2.6.35-28-generic
  validates :release, :length => 0..64, :presence => true
  
  # Kernel build number, e.g. #49-Ubuntu SMP Tue Mar 1 14:39:03 UTC 2011
  validates :version, :length => 0..128, :presence => true
  
  # Machine architecture, e.g. x86_64
  validates :architecture, :length => 0..64, :presence => true

  # Kernel OS string, e.g. GNU/Linux.
  validates :os, :length => 1..64, :presence => true
  
  # Updates the information to match the current machine state.
  #
  # The updated attributes are not automatically saved to the database.
  #
  # Args:
  #    ssh:: SSH session obtained from Machine#ssh_session (optional)
  #
  # Returns self, for call chaining.
  def update_by_ssh(ssh = nil)
    ssh ||= machine.ssh_session
    
    [
      [:name, '-s'], [:release, '-r'], [:version, '-v'], [:architecture, '-m'],
      [:os, '-o']
    ].each do |property, cli_arg|
      send :"#{property}=", ssh.exec!("uname #{cli_arg}").strip
    end
    self
  end
end
