module Gumby
  class Filter
    attr_reader :field
    attr_reader :kind
    attr_reader :val

    def initialize field, val, options = {}
      @field = field
      @kind  = Array === val ? :terms : :term
      @val   = val
    end

    def to_hash
      { kind => { field => val } }
    end
  end
end
