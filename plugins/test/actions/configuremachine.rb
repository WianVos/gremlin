
class ConfigureMachine < Dynflow::Action

  input_format do
    param :ip
    param :profile
    param :config_options
  end

  def run
    # for demonstration of resuming after error
      # for demonstration of resuming after error
      if ConfigureMachine.should_fail?
        ConfigureMachine.should_pass!
        raise "temporary unavailabe"
      end



    sleep(rand(5))
  end
  def self.should_fail?
    ! @should_pass
  end

  def self.should_pass!
    @should_pass = true
  end
end
