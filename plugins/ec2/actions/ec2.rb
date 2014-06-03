require 'fog'
module EC2
  module Connection

    # create a connection to aws
    # this method return a fog connection object
    # it gets it's parameters from the Dynflow::Action input method
    # so no need to pass parameters
    def connection

      return @connection if @connection
      p input[:mock]
      p "this is mocking"
      Fog.mock! if input[:mock] == 'true'
      begin
       Fog::Compute.new(
          :provider              => 'AWS',
          :region                => input[:region],
          :aws_access_key_id     => input[:aws_access_key_id],
          :aws_secret_access_key => input[:aws_secret_access_key] )
      rescue Exception => e
          raise "faild to build connection to EC2: #{e}"
      end
    end

  end
end