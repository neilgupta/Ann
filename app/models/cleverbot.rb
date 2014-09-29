require 'yaml'

# ActiveRecord wrapper for CleverBot API
class Cleverbot < ActiveRecord::Base
  attr_accessible :username, :serialized_bot
  belongs_to :brain

  before_save :save_bot

  validates :username, presence: true
  validates :brain, presence: true

  def think(input)
    bot.think input
  end

  def backlog
    bot.backlog
  end

  private

  def bot
    @bot ||= if serialized_bot
      YAML::load(serialized_bot)
    else
      CleverBot.new
    end
  end

  def save_bot
    self.serialized_bot = YAML::dump(bot)
  end
end