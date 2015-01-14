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

    unsent_instructions = Instruction.where("motor_id IN (?) and sent_at is null", motors.pluck(:id))
    
    rehashed_instructions = {}
    unsent_instructions.each do |i|
      rehashed_instructions[i.motor.address] ||= []
      rehashed_instructions[i.motor.address] << i.content
      i.delete
    end

    final_instructions = []
    rehashed_instructions.each { |key, val| final_instructions << {content: val.join(''), address: key} }

    final_instructions.to_json
  end
end
