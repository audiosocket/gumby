module Gumby
  class Sort
    def initialize field, direction
      @field     = field
      @direction = direction
    end

    def to_hash
      { @field => @direction }
    end
  end
end
