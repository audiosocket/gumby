require "gumby/search"

module Gumby
  def self.search target = :_all, &block
    Search.new target, &block
  end
end
