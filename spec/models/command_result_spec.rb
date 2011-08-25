require 'spec_helper'

describe CommandResult do
  fixtures :command_results, :shell_sessions

  before do
    @result = CommandResult.new
    @result.shell_session = shell_sessions :bunny1_update
    @result.command = 'cat'
    @result.exit_code = 0
    @result.stdin = "Input line\nInput line 2\n"
    @result.stdout = "Input line\nInput line 2\n"
    @result.stderr = "warning: could not open console\n"
  end
  
  it 'validates a good record' do
    @result.should be_valid
  end
  
  it 'accepts nil stdin' do
    @result.stdin = nil
    @result.should be_valid
  end
  
  it 'accepts empty stdin' do
    @result.stdin = ''
    @result.should be_valid 
  end
  
  it 'requires that stdout is set' do
    @result.stdout = nil
    @result.should_not be_valid
  end

  it 'requires that stderr is set' do
    @result.stderr = nil
    @result.should_not be_valid
  end
  
  it 'accepts a nil exit code' do
    @result.exit_code = nil
    @result.should be_valid
  end
  
  it 'rejects negative exit codes' do
    @result.exit_code = -1
    @result.should_not be_valid
  end
  
  it 'rejects non-numeric exit codes' do
    @result.exit_code = 'fail'
    @result.should_not be_valid
  end
  
  describe 'start!' do
    before do
      @result = shell_sessions(:bunny1_update).command_results.build
      @result.start! 'cat', 'stdin'
    end
    
    it 'generates a valid record' do
      @result.should be_valid
    end
    
    it 'records the given command line' do
      @result.command.should == 'cat'
    end
    
    it 'leaves the exit code as nil' do
      @result.exit_code.should be_nil
    end
    
    it 'records the given stdin' do
      @result.stdin.should == 'stdin'
    end
    
    it 'sets stdout to an empty string' do
      @result.stdout.should == ''
    end

    it 'sets stderr to an empty string' do
      @result.stderr.should == ''
    end
    
    it 'saves the changes' do
      @result.should_not be_changed
    end
    
    it 'does not work on an already started command' do
      lambda {
        @result.start! 'cat', 'stdin'
      }.should raise_error(RuntimeError)
    end

    it 'does not work on a completed command' do
      lambda {
        command_results(:bunny1_update_2).start! 'cat', 'stdin'
      }.should raise_error(RuntimeError)
    end
  end
  
  describe 'append_to_stdout!' do
    before do
      @result = command_results :bunny1_update_3
      @result.append_to_stdout! "Next line\n"
    end
    
    it 'modifies stdout correctly' do
      @result.stdout.should == "Linux\nNext line\n"
    end
    
    it 'does not touch stderr' do
      @result.stderr.should == "\n"
    end
    
    it 'saves the changes' do
      @result.should_not be_changed
    end
    
    it 'does not complete the command' do
      @result.should_not be_completed
    end

    it 'does not work on a completed command' do
      lambda {
        command_results(:bunny1_update_2).append_to_stdout! "Next line\n"
      }.should raise_error(RuntimeError)
    end
  end

  describe 'append_to_stderr!' do
    before do
      @result = command_results :bunny1_update_3
      @result.append_to_stderr! "Next line\n"
    end
    
    it 'modifies stderr correctly' do
      @result.stderr.should == "\nNext line\n"
    end
    
    it 'does not touch stdout' do
      @result.stdout.should == "Linux\n"
    end
    
    it 'saves the changes' do
      @result.should_not be_changed
    end

    it 'does not complete the command' do
      @result.should_not be_completed
    end
    
    it 'does not work on a completed command' do
      lambda {
        command_results(:bunny1_update_2).append_to_stderr! "Next line\n"
      }.should raise_error(RuntimeError)
    end
  end
end
