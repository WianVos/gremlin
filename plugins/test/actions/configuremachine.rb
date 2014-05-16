
class ConfigureMachine < Dynflow::Action

  input_format do
    param :ip
    param :profile
    param :config_options
  end

  def run
    # for demonstration of resuming after error

    sleep(rand(5))
  end

end
