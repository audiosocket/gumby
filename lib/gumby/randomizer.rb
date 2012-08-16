module Gumby
  class Randomizer
    def initialize salt
      @salt = salt
    end

    def to_hash
      {
        "_script" => {
          script: "salt.hashCode()",
          type:   "number",
          params: { salt: @salt },
          order:  "asc"
        }
      }
    end
  end
end
