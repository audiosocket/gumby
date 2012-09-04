module Gumby
  class Randomizer
    def to_hash
      {
        "_script" => {
          script: "random() * 20",
          type:   "number",
          order:  "asc"
        }
      }
    end
  end
end
