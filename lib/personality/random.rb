module Personality
  class Random < Base
    def generate_reaction(motor, sensor_type, data)
      # This is a random personality, we don't care about the incoming data
      # Just pick a character at random and return it
      [*('a'..'w')].sample(1).first
    end
  end
end
