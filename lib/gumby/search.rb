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
      @bools    = []
      @filters  = []
      @page     = 1
      @per_page = 50
      @sorts    = []
      @boosts   = []

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

    def boost amount, field, val
      @boosts << {
        boost:  amount,
        filter: Filter.new(field, val)
      }
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

    def to_hash
      build
    end

    private

    def build
      {}.tap do |body|
        unless @bools.empty?
          body[:query] ||= {}

          body[:query][:bool] = build_bools
        end

        body[:filter] = build_filters         unless @filters.empty?

        unless @boosts.empty?
          boosted_filters = []
          query = body.delete(:query)

          body[:query] = {
            function_score: {
              functions: boosted_filters,
            }
          }

          if query
            body[:query][:function_score][:query] = query
          end

          @boosts.each do |b|
            boosted_filters << {
              boost_factor:  b[:boost],
              filter: b[:filter].to_hash
            }
          end
        end

        if @boosts.empty? && !@sorts.empty?
          body[:sort]   = @sorts.map(&:to_hash)
        end

        body[:from] = (@page - 1) * @per_page
        body[:size] = @per_page
      end
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
  end
end
