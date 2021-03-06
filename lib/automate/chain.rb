module Automate

  # Captures the entire command chain to be executed. Thus, the main objective of this
  # class is to capture and execute the `ChainLinks`. All the capturing happens in the
  # `go` method, and the executing in the `run` method.
  #
  class Chain
    include Messenger

    # Factory method that creates a new command chain.
    #
    def self.which(task, &block)
      c = new(task)
      c.instance_exec(&block)
      c
    end

    # Add a new link to the command chain
    def go(desc, &block)
      add_command(desc, block)
    end

    # Run _all_ the command chain links. Will abort the command chain if any chain link
    # should fail.
    #
    def run(args = {})
      notice "About to run command chain which '#{@task}'"

      success = true
      begin
        args = run_command_list(@cmd_list, args)
      rescue ChainFailedError => e
        fail("Chain link ##{e.chain} (#{e.description}) failed.")
        success = false
      end

      notice "Running deferred commands"

      # Note that deferred commands are executed in reverse order, so that
      # the cleanup actions for the last command is executed first.
      # E.g. if the definition order is as follows:
      #
      #   C1, C1_defer, C2, C3, C4, C4_defer
      #
      # The execution order will be
      #
      #   C1, C2, C3, C4, C4_defer, C1_defer
      #
      args = run_command_list(@defer_list.reverse, args)
      if !success
        false
      else
        args
      end

    rescue ChainFailedError => e
      fail("Defer command ##{e.chain} (#{e.description}) failed.")
      false
    end


    def run_command_list(list, args)
      list.each_with_index do |cmd, index|
        desc, proc = cmd
        success "#{timestamp} // Running link ##{index+1} - #{desc}"

        error = false
        begin
          ret, out, chain_link_defer = ChainLink.invoke(proc, args)
          @defer_list += chain_link_defer
        rescue ChainLinkFailedError => e
          # TODO: Storing the defer_list in the ChainLinkFailedError is awful,
          # and shall be fixed when there's time to remove this entire exception-based
          # "communication" between chain and chain link.
          @defer_list += e.defer_list
          error = true
        end
        raise ChainFailedError.new(index + 1, desc) if ret == false || error == true

        # Pass the arguments from the last iteration, overwriting everything that
        # was passed from the current one.
        args.merge! out

        # Make it possible to run commands step by step
        if !ENV["AUTOMATE_STEP"].nil?
          puts "Press a key to continue..."
          $stdin.gets
          puts "\n"
        end
      end

      args
    end



  private

    # Private constructor. Instance creation is only allowed through `#which`.
    #
    private_class_method :new

    def initialize(task)
      @task = task
      @cmd_list = []
      @defer_list = []
    end

    def timestamp
      Time.now.strftime('%H:%M:%S.%L')
    end

    def add_command(desc, cmd)
      raise "Parameter must be a Proc/Lambda" if !cmd.is_a?(Proc)
      @cmd_list.push [desc, cmd]
    end



    # ========================
    # Messenger module related
    # ========================

    def prefix
      "=> "
    end
  end

end
