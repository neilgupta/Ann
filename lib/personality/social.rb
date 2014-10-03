module Personality
  class Social < Base
    def generate_reaction(motor, sensor_type, data)
      # Reply to tweets or generate tweets depending on other sensor data
      if sensor_type == 'twitter'
        user = data.user.screen_name
        # Find this user's chat history
        cb = motor.brain.cleverbots.find_or_create_by!(username: user)
        
        # Generate response
        # TODO make this smarter than just using cleverbot
        response = cb.think(data.text)

        # Tweet response
        twitter_client.update("@#{user} #{response}", {in_reply_to_status: data})
        
        # Save bot backlog
        cb.save!
      elsif sensor_type == 'motion'
        # If motion data is significantly higher or lower than usual, comment about it

      elsif sensor_type == 'sound'
        # If sound data is significantly higher or lower than usual, comment about it

      elsif sensor_type == 'weather' && data.precipProbability > 0.7
        !Input.joins(sensor: [brain: :motor]).where("motors.id = ? and sensors.type = ? and inputs.data ~ '\"precipProbability\"=>(1|0\\.[5-9])'", motor.id, 'weather').exists?
        # We haven't seen precipitation probabilities above 0.5 yet, and now suddenly it's at 0.7
        # so tweet about how it's going to flash rain
        
      end
    end
  end
end

# Sample tweet data
# "{\"created_at\":\"Sat Oct 16 17:07:46 +0000 2010\",\"id\":27558893223,\"id_str\":\"27558893223\",\"text\":\"Ruby is the best programming language for hiding the ugly bits.\",\"source\":\"<a href=\\\"http://www.echofon.com/\\\" rel=\\\"nofollow\\\">Echofon</a>\",\"truncated\":false,\"in_reply_to_status_id\":null,\"in_reply_to_status_id_str\":null,\"in_reply_to_user_id\":null,\"in_reply_to_user_id_str\":null,\"in_reply_to_screen_name\":null,\"user\":{\"id\":7505382,\"id_str\":\"7505382\",\"name\":\"Erik Michaels-Ober\",\"screen_name\":\"sferik\",\"location\":\"Prussia\",\"description\":\"Gemsbok\",\"url\":null,\"entities\":{\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":4884,\"friends_count\":548,\"listed_count\":287,\"created_at\":\"Mon Jul 16 12:59:01 +0000 2007\",\"favourites_count\":11025,\"utc_offset\":7200,\"time_zone\":\"Berlin\",\"geo_enabled\":true,\"verified\":false,\"statuses_count\":15212,\"lang\":\"en\",\"contributors_enabled\":false,\"is_translator\":false,\"is_translation_enabled\":false,\"profile_background_color\":\"000000\",\"profile_background_image_url\":\"http://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png\",\"profile_background_image_url_https\":\"https://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png\",\"profile_background_tile\":false,\"profile_image_url\":\"http://pbs.twimg.com/profile_images/511430750898376704/GnYJ7Ug2_normal.jpeg\",\"profile_image_url_https\":\"https://pbs.twimg.com/profile_images/511430750898376704/GnYJ7Ug2_normal.jpeg\",\"profile_banner_url\":\"https://pbs.twimg.com/profile_banners/7505382/1410514872\",\"profile_link_color\":\"201040\",\"profile_sidebar_border_color\":\"000000\",\"profile_sidebar_fill_color\":\"DDEEF6\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":false,\"follow_request_sent\":false,\"notifications\":false},\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":2,\"favorite_count\":4,\"entities\":{\"hashtags\":[],\"symbols\":[],\"urls\":[],\"user_mentions\":[]},\"favorited\":false,\"retweeted\":false,\"lang\":\"en\"}" 
