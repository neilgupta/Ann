class Brain < ActiveRecord::Base
  attr_accessible :name, :address, :extroversion_score, :active, :activated_at
  has_many :sensors
  has_many :motors
  has_many :cleverbots

  validates :address, presence: true

  def activate
    active = true
    activated_at = Time.now
    self.delay(run_at: Time.now.end_of_hour).chime
  end

  def deactivate
    active = false
  end

  def chime
    motors.where(personality: 'Weather').each do |m|
      m.instructions.create!(content: Instruction.convert_to_arduino_char('ACTION - CHIME'))
    end

    self.delay(run_at: Time.now.end_of_hour).chime
  end

  def fetch_instructions
    unsent_instructions = Instruction.where("motor_id IN (?) and sent_at is null", motors.pluck(:id))
    unsent_instructions.map do |i|
      i.touch(:sent_at)
      {content: i.content, motor: i.motor.address}
    end.to_json
  end
end
