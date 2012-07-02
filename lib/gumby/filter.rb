module Gumby
  class Filter
    attr_reader :field
    attr_reader :kind
    attr_reader :val

    def initialize field, val = nil
      @field = field
      @kind  = Array === val ? :terms : :term
      @val   = val
    end

    def greater_than value
      @gt = value
    end

    def less_than value
      @lt = value
    end

    def to_hash
      if @gt or @lt
        query = {}.tap do |q|
          q[:gt] = @gt if @gt
          q[:lt] = @lt if @lt
        end

        { range: { field => query } }
      else
        { kind => { field => val } }
      end
    end
  end
end
