class Instruction < ActiveRecord::Base
  attr_accessible :content, :sent_at
  belongs_to :motor

  validates :content, presence: true
  validates :motor, presence: true

  def self.convert_to_arduino_char(action)
    case action.upcase
    when 'ACTION - DANCE'     then 'a' # Rotate and nod randomly, rotate colors randomly 26s
    when 'ACTION - ALERT'     then 'b' # Rotate and flash red for 5 seconds, play hello sound 15s
    when 'ACTION - ROTATE'    then 'c' # Rotate once 15s
    when 'ACTION - NOD'       then 'd' # Nod twice 14s
    when 'ACTION - STOP'      then 'e' # Stand still and turn off lights 
    when 'ACTION - CHIME'     then 't' # Play an hourly chime given the hour number
    when 'ACTION - JOKE'      then 'p' # Play joke sound 7s
    when 'COLOR - GREEN'      then 'g' # Turn all lights green 
    when 'COLOR - BLUE'       then 'w' # Turn all lights blue
    when 'COLOR - RED'        then 'v' # Turn all lights red
    when 'WEATHER - SUNNY'    then 'i' # alternating blue and green ropes, play sunny sound 35s
    when 'WEATHER - RAINY'    then 'o' # alternating blue and off, play rainy sound 30s
    when 'WEATHER - CLOUDY'   then 'j' # 20% blue, 80% off 32s
    when 'WEATHER - DARK'     then 'l' # all off, play night sound 32s
    when 'WEATHER - SNOWY'    then 'm' # single red rope randomly moving around 20s
    when 'WEATHER - SUNRISE'  then 'n' # alternating blue and red 5s
    when 'WEATHER - COLD'     then 'o' # single blue rope randomly moving around 
    when 'EMOTION - HAPPY'    then 'f' # dance?, play laugh sound 7s
    when 'EMOTION - SAD'      then 'r' # Turn lights blue and yellow, rotate slowly 16s
    when 'EMOTION - STARTLED' then 's' # Flash green lights, play shrug sound 10s
    when 'EMOTION - ANGRY'    then 'h' # Turn red for a second, play growl sound 4s
    when 'EMOTION - CONFUSED' then 'q' # Use all 3 colors in a random pattern, play surprised sound 9s
    when 'EMOTION - SOCIAL'   then 'd' # nod?
    when 'EMOTION - HUNGRY'   then 'g' # turn green for a second, play growl sound
    else action
    end
  end

  def self.flock_timer(action)
    case action
    when 'a' then 27
    when 'b' then 15
    when 'c' then 15
    when 'd' then 14
    when 'p' then 7
    when 'i' then 35
    when 'o' then 30
    when 'j' then 32
    when 'l' then 32
    when 'm' then 20
    when 'n' then 5
    when 'f' then 7
    when 'r' then 16
    when 's' then 10
    when 'h' then 5
    when 'q' then 9
    else 5
    end
  end
end