require_relative '../actions/ec2'
module EC2
  class CheckResult < Gremlin::Action
    include EC2::Connection

    input_format do
      param :region, string
      param :id, string
      param :aws_access_key_id, string
      param :aws_secret_access_key, string
    end

    def run

      while server(input[:id]).state != 'running'
        sleep 5
      end


    end

    private

    def server(id)
      connection.servers.get(id)
    end


  end
end