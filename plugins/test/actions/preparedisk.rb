class PrepareDisk < Dynflow::Action

  input_format do
    param :name
  end

  output_format do
    param :path
  end

  def run
    sleep(rand(5))
    output[:path] = "/var/images/#{input[:name]}.img"
  end

end
