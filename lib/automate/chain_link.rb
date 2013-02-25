module Automate

  # Represents a single link of a command chain, which takes a number
  # of input parameters (`@in_args`), does some magic, returning a
  # number of output arguments (`@out_args`).
  #
  # A chain link is created by the `Chain#go` method. The block passed to
  # said method contains the logic which is later executed within this
  # class (by #invoke).
  #
  class ChainLink
    include Messenger

    def self.invoke(proc, args)
      new(args).invoke(proc)
    end

    # Invokes the block passed to the `#go` method. Said block will be able to call the
    # methods listed in the "Public API" section.
    #
    def invoke(proc)
      ret = instance_exec(&proc)
      [ret, @out_args]

    rescue UnmetDemandError => e
      fail "Required argument '#{e.demand}', but was not given."
      raise ChainLinkFailedError.new
    rescue CmdFailedError => e
      fail e.message
      raise ChainLinkFailedError.new
    end



    # ==========
    # Public API
    # ==========

    # Runs a given shell command, aborting the command chain if there is an error.
    #
    def run(cmd, capture_stderr=true)
      notice "Running: " + cmd.color(:white)
      cmd += " 2>&1" if capture_stderr

      out = ""
      IO.popen(cmd) do |f|
        while l = f.gets
          out += l
          msg "        " + l
        end
      end

      raise CmdFailedError.new("Command '#{cmd}' had exit status != 0.") if $? != 0
      out
    end

    # Passes an argument onto the next link of the chain
    def pass(key, value)
      @out_args[key] = value
    end

    # Requires that an argument must be present before proceeding in the current
    # chain
    def demand(*keys)
      keys.each do |key|
        raise UnmetDemandError.new(key) if !@in_args.has_key? key
      end
    end

    # Implement method_missing so that we can address passed variables using the
    # `_variablename` shorthand within a chain link.
    def method_missing(method, *args, &block)
      if method.to_s =~ /^_(.+)$/
        arg = @in_args[$1.to_sym] || @out_args[$1.to_sym]
        return arg if !arg.nil?
      end

      super
    end



    # ========================
    # Messenger module related
    # ========================

    def prefix
      "    => "
    end


  private

    # Private constructor. Instance creation is only allowed through `#invoke`.
    #
    private_class_method :new

    def initialize(args)
      @in_args = args
      @out_args = {}
    end

  end

end
