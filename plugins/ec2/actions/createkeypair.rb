require 'fog'

module EC2
  class CreateKeyPair < Dynflow::Action

    input_format do
      param :region, string
    end

    output_format do
      param :key_pair_name, string
      param :key_file, string
      param :key_fingerprint, string
    end

    def run
      key_pair = connection.key_pairs.create(:name => key_pair_name )

      write_key_to_file(key_pair.private_key)

      output[:key_pair_name] = key_pair_name
      output[:key_file] = key_file
      output[:key_fingerprint] = key_pair.fingerprint

    end

    def finalize
      puts "we've created a key for you named: #{key_pair_name} and stored it in #{key_file}"
    end

    private

    #generate a random keypair name
    def key_pair_name

      # return the key_pair_name if one is already generated
      return @key_pair_name if @key_pair_name

      # generate on from a random string of 10 upper and lowercase letters
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      @key_pair_name = (0..10).map { o[rand(o.length)] }.join
      return @key_pair_name

    end

    def key_file

      return @key_file if @key_file

      @key_file = key_storage + "/" + key_pair_name + ".pem"

    end

    def key_storage
     '/tmp'
    end

    def connection
      # return if already setup
      return @connection if @connection

      @connection = Fog::Compute.new(
          :provider              => 'AWS',
          :region                => input[:region],
          :aws_access_key_id     => aws_access_key_id,
          :aws_secret_access_key => aws_secret_access_key )

    end

    def write_key_to_file(private_key)
      File.open(key_file, 'w') { |file| file.write(private_key) }
    end

    def aws_access_key_id
      'AKIAIDA6NLQQF7SEZMNQ'
    end
    def aws_secret_access_key
      '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'
    end

  end
end