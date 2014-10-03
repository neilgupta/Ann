class Motor < ActiveRecord::Base
  attr_accessible :name, :address, :type, :personality
  has_many :instructions
  belongs_to :brain

  validates :brain, presence: true
  validates :type, presence: true
  validates :personality, presence: true

  def received_data(sensor_type, data)
    personality_class = "Personality::#{personality}".constantize
    personality_engine = personality_class.new
    instruction = personality_engine.react(self, sensor_type, data)
    instructions.create!(content: Instruction.convert_to_arduino_char(instruction)) if instruction && address
  end
end