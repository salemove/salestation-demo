module Demo
  class Environment
    attr_reader :logger

    def initialize(logger:)
      @logger = logger
    end
  end
end
