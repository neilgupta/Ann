class Instruction < ActiveRecord::Base
  attr_accessible :content, :sent_at
  belongs_to :motor

  validates :content, presence: true
  validates :motor, presence: true

  def self.convert_to_arduino_char(action)
    case action.upcase
    when 'ACTION - DANCE'     then 'a' # Rotate and nod randomly, rotate colors randomly
    when 'ACTION - ALERT'     then 'b' # Rotate and flash red for 5 seconds
    when 'ACTION - ROTATE'    then 'c' # Rotate once
    when 'ACTION - NOD'       then 'd' # Nod twice
    when 'ACTION - STOP'      then 'e' # Stand still and turn off lights
    when 'COLOR - GREEN'      then 'f' # Turn all lights green
    when 'COLOR - BLUE'       then 'g' # Turn all lights blue
    when 'COLOR - RED'        then 'h' # Turn all lights red
    when 'WEATHER - SUNNY'    then ‘i’ # alternating blue and green ropes
    when 'WEATHER - RAINY'    then ‘j’ # alternating blue and off
    when 'WEATHER - CLOUDY'   then ‘k’ # 20% blue, 80% off
    when 'WEATHER - DARK'     then ‘l’ # all off
    when 'WEATHER - SNOWY'    then ‘m’ # single red rope randomly moving around
    when 'WEATHER - SUNRISE'  then ’n’ # alternating blue and red
    when 'WEATHER - COLD'     then ‘o’ # single blue rope randomly moving around
    when 'EMOTION - HAPPY'    then 'p' # dance?
    when 'EMOTION - SAD'      then 'q' # Turn lights blue and yellow, rotate slowly
    when 'EMOTION - STARTLED' then ‘r’ # Flash green lights
    when 'EMOTION - ANGRY'    then ’s’ # Turn red for a second
    when 'EMOTION - CONFUSED' then ’t’ # Use all 3 colors in a random pattern
    when 'EMOTION - SOCIAL'   then ‘u’ # nod?
    when 'EMOTION - HUNGRY'   then ‘v’ # turn green for a second
    else action
    end
end