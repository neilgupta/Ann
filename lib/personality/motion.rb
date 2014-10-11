module Personality
  class Motion < Base
    def generate_reaction(motor, sensor_type, data)
      return unless sensor_type == 'motion' || sensor_type == 'sound'

      if sensor_type == 'motion'

        # do something
        

        # if it's been more than 10 min since last motion, say hello!
        unless Input.joins(sensor: [brain: :motor]).where("motors.id = ? and sensors.sensor_type = 'motion' and age(inputs.created_at) < interval '10 minutes'", motor.id).exists?
          return 'ACTION - JOKE'
        end

      elsif sensor_type == 'sound'

        # do something else

        # if there is a lot of noise

      end
    end
  end
end
