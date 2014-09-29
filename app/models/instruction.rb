class Instruction < ActiveRecord::Base
  attr_accessible :content, :sent_at
  belongs_to :motor

  validates :content, presence: true
  validates :motor, presence: true
end