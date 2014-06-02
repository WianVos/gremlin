module EC2
  class CheckResult < Gremlin::Action

    input_format do
      param :region, string
      param :id, string
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

    # setup a aws connection
    def connection
      # return if already setup
      return @connection if @connection

      @connection = Fog::Compute.new(
          :provider              => 'AWS',
          :region                => input[:region],
          :aws_access_key_id     => aws_access_key_id,
          :aws_secret_access_key => aws_secret_access_key )

    end


    def aws_access_key_id
      'AKIAIDA6NLQQF7SEZMNQ'
    end
    def aws_secret_access_key
      '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'
    end
  end
end