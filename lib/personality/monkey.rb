module Personality
  class Monkey < Base
    def generate_reaction(motor, sensor_type, data)
      brain = motor.brain
      extrovert_score = brain.extroversion_score

      # Find the last time somebody interacted with Ann
      last_interaction = Input.joins(sensor: :brain).where("brains.id = ? and (sensors.type = 'monkey' or (sensors.type = 'twitter' and inputs.data ~ '\"user_mentions\":\[[^\]]*\"annsbrain\"\]'))").order("inputs.created_at desc").limit(1).pluck(:created_at).first
      # How long has it been since that interaction?
      diff_in_minutes = (Time.now - last_interaction)/60

      is_confused = false

      # Possible inputs are motion data from monkey or tweets from twitter
      # Output is EMOTION instructions and tweets
      # extrovert_score decides how monkey reacts
      if sensor_type == 'monkey'
        # Gain half an extroversion point everytime somebody picks up the monkey
        extrovert_score += 0.5 if extrovert_score < 100
      elsif sensor_type == 'twitter'
        # Gain an extroversion point everytime somebody tweets at us
        extrovert_score += 1 if data.entities.user_mentions.include?('annsbrain') && extrovert_score < 100
        is_confused = data.text =~ /\?/
      else
        # Lose an extrovert point everytime a sensor is triggered that's not somebody interacting with Ann
        extrovert_score -=1 if extrovert_score > 0
      end

      did_interact = extrovert_score >= brain.extrovert_score

      brain.extroversion_score = extrovert_score
      brain.save!

      if did_interact && diff_in_minutes > 20 && extrovert_score < 50
        return 'EMOTION - STARTLED'
      elsif did_interact && extrovert_score < 20
        return 'EMOTION - ANGRY'
      elsif did_interact && extrovert_score > 80
        return 'EMOTION - HAPPY'
      elsif is_confused
        return 'EMOTION - CONFUSED'
      elsif !did_interact && extrovert_score > 80
        return 'EMOTION - SAD'
      elsif !did_interact && extrovert_score < 5
        return 'EMOTION - HAPPY'
      end
      
    end
  end
end


    # when 'EMOTION - HAPPY'    then 'p' # Turn all lights green and dance
    # when 'EMOTION - SAD'      then 'q' # Turn lights blue and yellow, rotate slowly
    # when 'EMOTION - STARTLED'    then 't'
    # when 'EMOTION - ANGRY'    then 'u'
    # when 'EMOTION - CONFUSED' then 'v'
