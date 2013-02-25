module Automate

  class ChainLinkFailedError < Exception; end
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
