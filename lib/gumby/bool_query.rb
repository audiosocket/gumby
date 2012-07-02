module Gumby
  class BoolQuery
    attr_reader :clause

    def initialize field, val, clause = :must_not
      @clause = clause
      @field  = field
      @filter = Array === val ? :terms : :term
      @val    = val
    end

    def to_hash
      { @filter => { @field => @val } }
    end
  end
end
