module Personality
  class Api < Base
    def generate_reaction(motor, sensor_type, data)
      return unless sensor_type == 'twitter'

      # Allow tweets to command flocks
      case data.text.downcase
      when 'dance'
        'ACTION - DANCE'
      when 'rotate'
        'ACTION - ROTATE'
      when 'nod'
        'ACTION - NOD'
      when 'stop'
        'ACTION - STOP'
      when 'green'
        'COLOR - GREEN'
      when 'red'
        'COLOR - RED'
      when 'blue'
        'COLOR - BLUE'
      end
    end
  end
end
