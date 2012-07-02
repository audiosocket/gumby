require "gumby/bool_query"
require "gumby/filter"
require "gumby/sort"

module Gumby
  class Search
    attr_reader :bools
    attr_reader :filters
    attr_reader :sorts

    def initialize target, &block
      @filters = []
      @bools   = []
      @sorts   = []

      instance_exec(&block) if block_given?

      build
    end

    def exclude field, val
      @bools << BoolQuery.new(field, val, :must_not)
    end

    def filter field, val
      @filters << Filter.new(field, val)
    end

    def sort field, direction
      @sorts << Sort.new(field, direction)
    end

    def text val
    end

    def to_hash
      build
    end

    private

    def build
      {}.tap do |body|
        body[:filter] = build_filters         unless @filters.empty?
        body[:sort]   = @sorts.map(&:to_hash) unless @sorts.empty?

        unless @bools.empty?
          body[:query] ||= {}

          body[:query][:bool] = build_bools
        end
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
