module Personality
  class Monkey < Base
    def generate_reaction(motor, sensor_type, data)
      return unless sensor_type == 'monkey' || sensor_type == 'twitter'

      brain = motor.brain
      extrovert_score = brain.extroversion_score

      # Possible inputs are motion data from monkey or tweets from twitter
      # Output is EMOTION instructions and tweets
      # extrovert_score decides how monkey reacts
      
    end
  end
end
