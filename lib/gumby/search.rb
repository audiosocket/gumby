require "gumby/bool_query"
require "gumby/filter"
require "gumby/randomizer"
require "gumby/sort"
require "gumby/text_query"

module Gumby
  class Search
    attr_reader :bools
    attr_reader :filters
    attr_reader :sorts
    attr_reader :page
    attr_reader :per_page

    def initialize target, &block
      @bools     = []
      @filters   = []
      @functions = []
      @page      = 1
      @per_page  = 50
      @sorts     = []

      instance_exec(&block) if block_given?

      build
    end

    def exclude field, val
      @bools << BoolQuery.new(field, val, :must_not)
    end

    def filter field, val = nil
      filter = Filter.new(field, val)

      @filters << filter

      filter
    end

    def paginate page, per_page
      @page     = page     if page
      @per_page = per_page if per_page
    end

    def randomize
      @sorts << Randomizer.new
    end

    def sort field, direction
      @sorts << Sort.new(field, direction)
    end

    def text val, field = nil
      @bools << TextQuery.new(val, field)
    end

    def function_score function
      @functions << function
    end

    def boost amount, field, val
      @functions << {
        boost:  amount,
        filter: Filter.new(field,val).to_hash
      }
    end

    def to_hash
      build
    end

    private

    def build
      body = {}

      unless @bools.empty?
        body[:query] ||= {}

        body[:query][:bool] = build_bools
      end

      body[:filter] = build_filters         unless @filters.empty?
      body[:sort]   = @sorts.map(&:to_hash) unless @sorts.empty?

      body[:from] = (@page - 1) * @per_page
      body[:size] = @per_page

      unless @functions.empty?

        query = body.delete(:query)

        body[:query] = {
          function_score: {
            functions: build_functions
          }
        }

        if query
          body[:query][:function_score][:query] = query
        end

      end

      if @functions.empty? && !@sorts.empty?
        body[:sort] = @sorts.map(&:to_hash)
      end

      body
    end

    def build_bools
      bools = {}

      @bools.each do |b|
        bools[b.clause] ||= []
        bools[b.clause] << b.to_hash
      end

      bools
    end

    def build_filters
      filters = { "and" => [] }

      @filters.each { |f| filters["and"] << f.to_hash }

      filters
    end

    def build_functions
      @functions.dup
    end
  end
end
