class Brain < ActiveRecord::Base
  attr_accessible :name, :address, :extroversion_score, :active, :activated_at, :last_polled, :last_error_email_sent
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
    self.touch(:last_polled)

    i = Instruction.where("motor_id IN (?)", motors.pluck(:id)).first
    final_instructions = [{content: i.content, address: i.motor.address, timer: Instruction.flock_timer(i.content)}]
    i.delete

    final_instructions.to_json
  end
end
