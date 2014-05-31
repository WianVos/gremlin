require 'fileutils'

module Gremlin
  class Daemon

    def self.run
      STDERR.puts("Starting gremlin environment")
      STDERR.puts("Starting listener")
      p "fuck"
      daemon = Dynflow::Daemon.new(Gremlin.listener, Gremlin.world, Gremlin.lock_file)
      STDERR.puts("Everything ready")
      daemon.run
    end

    # run the executor as a daemon
    def self.run_background(command = "start", options = {})
      default_options = { process_name: 'dynflow_executor',
                          pid_dir: "/tmp/pids",
                          wait_attempts: 300,
                          wait_sleep: 1 }
      options = default_options.merge(options)
      FileUtils.mkdir_p(options[:pid_dir])
      begin
        require 'daemons'
      rescue LoadError
        raise "You need to add gem 'daemons' to your Gemfile if you wish to use it."
      end

      unless %w[start stop restart run].include?(command)
        raise "Command exptected to be 'start', 'stop', 'restart', 'run', was #{command.inspect}"
      end

      STDERR.puts("Dynflow Executor: #{command} in progress")

      Daemons.run_proc(options[:process_name],
                       :dir => options[:pid_dir],
                       :dir_mode => :normal,
                       :monitor => true,
                       :log_output => true,
                       :ARGV => [command]) do |*args|
        begin
          run
        rescue => e
          STDERR.puts e.message
          exit 1
        end
      end
      if command == "start" || command == "restart"
        STDERR.puts('Waiting for the executor to be ready...')
        options[:wait_attempts].times do |i|
          STDERR.print('.')
          if File.exists?(Gremlin.lock_file)
            STDERR.puts('executor started successfully')
            break
          else
            sleep options[:wait_sleep]
          end
        end
      end
    end
  end
end