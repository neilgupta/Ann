module Personality
  class Api < Base
    def generate_reaction(motor, sensor_type, data)
      return unless sensor_type == 'twitter'

      # Allow tweets to command flocks
      case data.text.downcase
      when 'dance'
        Instruction.convert_to_arduino_char('ACTION - DANCE')
      when 'rotate'
        Instruction.convert_to_arduino_char('ACTION - ROTATE')
      when 'nod'
        Instruction.convert_to_arduino_char('ACTION - NOD')
      when 'stop'
        Instruction.convert_to_arduino_char('ACTION - STOP')
      when 'green'
        Instruction.convert_to_arduino_char('COLOR - GREEN')
      when 'red'
        Instruction.convert_to_arduino_char('COLOR - RED')
      when 'blue'
        Instruction.convert_to_arduino_char('COLOR - BLUE')
      end
    end
  end
end
