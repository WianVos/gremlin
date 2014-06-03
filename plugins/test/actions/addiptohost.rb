class AddIPtoHosts < Dynflow::Action

  input_format do
    param :ip
  end

  def run
    sleep(rand(5))
  end

end
