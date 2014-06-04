require_relative '../actions/ec2'


module EC2
  class CreateInstance < Gremlin::Action
    include EC2::Connection


    input_format do
      param :ami, string
      param :region, string
      param :type, string
      param :key_pair_name, string
      param :aws_access_key_id, string
      param :aws_secret_access_key, string
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




  end
end