require 'fog'

module EC2
  class CreateInstance < Gremlin::Action


    input_format do
      param :ami, string
      param :region, string
      param :type, string
      param :key_pair_name, string
    end

    output_format do
      param :id, string
      param :dns, string
    end

    def run
      server = connection.servers.create(:imageid => input[:ami],
                                         :flavor_id => input[:type],
                                         :key_name  => input[:key_pair_name])

      #until server.state == 'running' do
      #  sleep 10
      #  puts "#{server.dns_name}: #{server.state}"
      #end

      output[:id]  = server.id
      output[:dns] = server.dns_name

    end

    private

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

    private
    def aws_access_key_id
      'AKIAIDA6NLQQF7SEZMNQ'
    end
    def aws_secret_access_key
      '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'
    end
  end
end