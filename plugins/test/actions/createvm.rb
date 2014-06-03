class CreateVM < Dynflow::Action

  input_format do
    param :name
    param :disk
  end

  output_format do
    param :ip
  end

  def run
    sleep(rand(5))
    output[:ip] = "192.168.100.#{rand(256)}"
  end

end
