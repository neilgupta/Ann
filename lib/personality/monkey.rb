module Personality
  class Monkey < Base
    def generate_reaction(motor, sensor_type, data)
      brain = motor.brain
      extrovert_score = brain.extroversion_score

      # Find the last time somebody interacted with Ann
      last_interaction = Input.joins(sensor: :brain).where("brains.id = ? and (sensors.sensor_type = 'monkey' or (sensors.sensor_type = 'twitter' and inputs.data ~ '\"user_mentions\":\[[^\]]*\"annsbrain\"\]'))").order("inputs.created_at desc").limit(1).pluck(:created_at).first
      # How long has it been since that interaction?
      diff_in_minutes = (Time.now - last_interaction)/60

      emotion = nil

      # Possible inputs are motion data from monkey or tweets from twitter
      # Output is EMOTION instructions and tweets
      # extrovert_score decides how monkey reacts
      if sensor_type == 'monkey'
        # Gain half an extroversion point everytime somebody picks up the monkey
        extrovert_score += 0.5 if extrovert_score < 100
      elsif sensor_type == 'twitter' && data.entities.user_mentions.include?('annsbrain')
        # Gain an extroversion point everytime somebody tweets at us
        extrovert_score += 1 if extrovert_score < 100
        emotion = case data.text
        when /(hunge?ry?|food|lunch|dinner)/i then 'hungry'
        when /\?/ then 'confused'
        else
          nil
        end
      else
        # Lose extrovert points everytime a sensor is triggered that's not somebody interacting with Ann
        extrovert_score -= 0.003 if extrovert_score > 0
      end

      # Did the score increase as a result of these interactions?
      did_interact = extrovert_score >= brain.extrovert_score && extrovert_score > 0

      brain.extroversion_score = extrovert_score
      brain.save!

      if did_interact && diff_in_minutes > 20
        # Get startled when first interacting after 20 minutes
        return 'EMOTION - STARTLED'
      elsif did_interact && extrovert_score < 30
        # Show anger when interacting while introverted
        return 'EMOTION - ANGRY'
      elsif did_interact && extrovert_score > 70
        # Show happy when interacting while extroverted
        return 'EMOTION - HAPPY'
      elsif emotion == 'confused'
        # Show confused whenever a question is asked
        return 'EMOTION - CONFUSED'
      elsif emotion == 'hungry'
        return 'EMOTION - HUNGRY'
      elsif did_interact
        # Extroversion score between 30 - 70, we're average, so just be social
        return 'EMOTION - SOCIAL'
      elsif !did_interact && extrovert_score > 70 && diff_in_minutes > 2 && diff_in_minutes % 10 < 2
        # Show sad emotion when extroverted every 10 minutes it is ignored
        return 'EMOTION - SAD'
      elsif !did_interact && extrovert_score < 10 && diff_in_minutes > 2 && diff_in_minutes % 15 < 2
        # Show happy emotion when introverted every 15 minutes that it is ignored
        return 'EMOTION - HAPPY'
      end
      
    end
  end
end


    # when 'EMOTION - HAPPY'    then 'p' # Turn all lights green and dance
    # when 'EMOTION - SAD'      then 'q' # Turn lights blue and yellow, rotate slowly
    # when 'EMOTION - STARTLED' then 't'
    # when 'EMOTION - ANGRY'    then 'u'
    # when 'EMOTION - CONFUSED' then 'v'
