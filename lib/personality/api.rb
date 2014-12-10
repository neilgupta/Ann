module Personality
  class Api < Base
    def generate_reaction(motor, sensor_type, data)
      return unless sensor_type == 'twitter'

      # Allow tweets to command flocks
      case data.text.downcase
      when '@annsbrain dance'
        'ACTION - DANCE'
      when '@annsbrain rotate'
        'ACTION - ROTATE'
      when '@annsbrain nod'
        'ACTION - NOD'
      when '@annsbrain stop'
        'ACTION - STOP'
      when '@annsbrain green'
        'COLOR - GREEN'
      when '@annsbrain red'
        'COLOR - RED'
      when '@annsbrain blue'
        'COLOR - BLUE'
      when '@annsbrain rain'
        'WEATHER - RAIN'
      end
    end
  end
end
