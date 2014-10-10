module Personality
  class Random < Base
    def generate_reaction(motor, sensor_type, data)
      # This is a random personality, we don't care about the incoming data
      # Just pick a character at random and return it
      command = [*('a'..'z'), *(1..20)].sample(1).first
      # Don't return anything if we picked a number
      return command unless command.is_a?(Numeric)
    end
  end
end
