module Gumby
  class TextQuery
    attr_reader :clause

    def initialize val, field
      @clause = :should
      @field  = field || :_all
      @filter = :text
      @val    = val
    end

    def to_hash
      { @filter => { @field => @val } }
    end
  end
end
