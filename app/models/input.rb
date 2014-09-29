class Input < ActiveRecord::Base
  attr_accessible :data
  belongs_to :sensor

  validates :data, presence: true
  validates :sensor, presence: true
end