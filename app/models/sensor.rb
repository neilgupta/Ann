class Sensor < ActiveRecord::Base
  attr_accessible :name, :address, :sensor_type
  has_many :inputs
  belongs_to :brain

  scope :active, -> { joins(:brain).where("brains.active is true") }

  validates :sensor_type, presence: true
  validates :brain, presence: true

  def save_data(data, serializable_data = nil)
    return unless data

    # If serializable_data is not provided, assume data is serializable
    # inputs.create!(data: JSON.generate(serializable_data || data))

    # Notify all motors
    type_of_sensor = sensor_type == 'twitter' && data == :follow ? 'twitter_event' : sensor_type
    brain.motors.each {|m| m.received_data(type_of_sensor, data)}
  end
end