class Brain < ActiveRecord::Base
  attr_accessible :name, :address, :extroversion_score, :active, :activated_at
  has_many :sensors
  has_many :motors
  has_many :cleverbots

  validates :address, presence: true

  def activate
    active = true
    activated_at = Time.now
  end

  def deactivate
    active = false
  end

  def fetch_instructions
    unsent_instructions = Instruction.where("motor_id IN (?) and sent_at is null", motors.pluck(:id))
    unsent_instructions.map do |i|
      i.touch(:sent_at)
      {content: i.content, motor: i.motor.address}
    end.to_json
  end
end