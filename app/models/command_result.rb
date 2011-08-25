# Records the result of a command issued in a shell session.
#
# CommandResults are created as soon as a command begins executing, and are
# modified throughout command execution.
class CommandResult < ActiveRecord::Base
  # The session during which the command was issued.
  belongs_to :shell_session, :inverse_of => :command_results
  validates :shell_session, :presence => true
  
  # The command line for the issued command.
  validates :command, :presence => true, :length => 1..1024
  
  # The exit code of the process that executed the command.
  validates :exit_code, :numericality => { :allow_nil => true,
      :integer_only => true, :greater_or_equal_to => 0 }
  # The data fed to the standard input of the process that executed the command.
  validates :stdin, :length => { :in => 0..64.kilobytes, :allow_nil => true }
  # The standard output of the process that executed the command.
  validates :stdout, :length => { :in => 0..64.kilobytes, :allow_nil => false }
  # The standard error output of the process that executed the command.
  validates :stderr, :length => { :in => 0..64.kilobytes, :allow_nil => false }
  
  # No attributes can be changed from a Web form.
  attr_accessible

  # True if the command's exit code indicates success.
  def succeeded?
    exit_code == 0
  end
  
  # True if the command finished executing.
  def completed?
    !exit_code.nil?
  end
  
  # Records new data coming from the standard output of the command's process.
  def append_to_stdout!(stdout_fragment)
    raise "Command already finished executing" if completed?
    self.stdout += stdout_fragment
    save!
    self
  end
  
  # Records new data coming from the standard error of the command's process.
  def append_to_stderr!(stderr_fragment)
    raise "Command already finished executing" if completed?
    self.stderr += stderr_fragment
    save!
    self
  end
  
  # Records the completion of the command's execution.
  def completed!(exit_code)
    raise "Command already finished executing" if completed?
    self.exit_code = exit_code
    save!
    self
  end
end
