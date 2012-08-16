require "gumby"
require "minitest/autorun"

describe Gumby do
  it "searches things" do
    s = Gumby.search do
      exclude :fruit, :tomato

      sort :fruit, :asc

      randomize "salt"
    end
  end
end


