require "gumby"
require "minitest/autorun"

describe Gumby do
  it "searches things" do
    s = Gumby.search do
      exclude :fruit, :tomato

      sort :fruit, :asc

      # randomize "salt"
    end
  end

  it "boosts stuff" do
    s = Gumby.search do
      exclude :fruit, :tomato

      sort :fruit, :asc

      boost 4, :fruit, 34
    end

    p s.to_hash
  end

end


