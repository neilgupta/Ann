class Sensor < ActiveRecord::Base
  attr_accessible :name, :address, :type
  has_many :inputs
  belongs_to :brain

  scope :active, -> { joins(:brain).where("brains.active is true") }

  validates :type, presence: true
  validates :brain, presence: true

  def save_data(data, serializable_data = nil)
    return unless data

    # If serializable_data is not provided, assume data is serializable
    inputs.create!(data: JSON.generate(serializable_data || data))

    # Notify all motors
    brain.motors.each {|m| m.received_data(type, data)}
  end
end