module Automate

  class ChainLinkFailedError < Exception
    attr_reader :defer_list
    def initialize(defer_list)
      super
      @defer_list = defer_list
    end
  end

  class CmdFailedError < Exception; end

  class ChainFailedError < Exception
    attr_reader :chain, :description
    def initialize(chain, description)
      @chain = chain
      @description = description
    end
  end

  class UnmetDemandError < Exception;
    attr_reader :demand
    def initialize(demand)
      @demand = demand
    end
  end

end
