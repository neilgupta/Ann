class Instruction < ActiveRecord::Base
  attr_accessible :content, :sent_at
  belongs_to :motor

  validates :content, presence: true
  validates :motor, presence: true

  def self.convert_to_arduino_char(action)
    case action.upcase
    when 'ACTION - DANCE'     then 'a' # Rotate and nod randomly, rotate colors randomly
    when 'ACTION - ALERT'     then 'b' # Stand still and turn red
    when 'ACTION - ROTATE'    then 'c' # Rotate once
    when 'ACTION - NOD'       then 'd' # Nod twice
    when 'ACTION - STOP'      then 'e' # Stand still and turn off lights
    when 'COLOR - GREEN'      then 'f' # Turn all lights green
    when 'COLOR - BLUE'       then 'g' # Turn all lights blue
    when 'COLOR - RED'        then 'h' # Turn all lights red
    when 'WEATHER - SUNNY'    then 'i' # Turn all lights blue
    when 'WEATHER - RAINY'    then 'j'
    when 'WEATHER - CLOUDY'   then 'k'
    when 'WEATHER - DARK'     then 'l'
    when 'WEATHER - SNOWY'    then 'm'
    when 'WEATHER - SUNRISE'  then 'n'
    when 'WEATHER - COLD'     then 'o'
    when 'EMOTION - HAPPY'    then 'p' # Turn all lights green and dance
    when 'EMOTION - SAD'      then 'q' # Turn lights blue and yellow, rotate slowly
    when 'EMOTION - INTROVERTED' then 'r' # Turn 
    when 'EMOTION - EXTROVERTED' then 's' # Turn 
    when 'EMOTION - STARTLED'    then 't'
    when 'EMOTION - ANGRY'    then 'u'
    when 'EMOTION - CONFUSED' then 'v'
    when 'EMOTION - ANGSTY'   then 'w'
    else action
    end
end