module Automate

  module Messenger
    def format(x)
      "#{prefix}#{x}"
    end

    def msg(x)
      puts format(x)
    end

    def success(x, y="")
      puts format(x).color(:green) + y
    end

    def notice(x, y="")
      puts format(x).color(:yellow) + y
    end

    def fail(x, y="")
      puts format(x).color(:red) + y
    end

    # Overwrite these in your importing class
    def prefix; raise NotImplementedError; end
  end

end
