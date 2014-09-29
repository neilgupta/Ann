require 'digest/md5'

class CleverBot
  def initialize
    @service_uri = 'http://www.cleverbot.com/webservicemin'
    @post_params = {
      start: 'y',
      icognoid: 'wsf',
      fno: '0',
      sub: 'Say',
      islearning: '1',
      cleanslate: 'false'
    }
    @backlog = []
  end

  def puppet(thought, answer)
    # Maintain CleverBot emotional history by making a request for this thought
    @post_params['stimulus'] = thought
    response_data = make_request
    save_post response_data

    # Insert forced answer instead of saving CleverBot's response
    response_data = []
    response_data[8] = thought
    response_data[16] = answer
    response = CleverBotResponse.new response_data
    @backlog.push response
    response.answer
  end

  def think thought
    @post_params['stimulus'] = thought
    response_data = make_request
    save_post response_data
    response = CleverBotResponse.new response_data
    @backlog.push response
    response.answer
  end

  def backlog
    @backlog.map(&:dup)
  end

  private
  def build_query
    current_query = to_querystring
    @post_params['icognocheck'] = Digest::MD5.hexdigest current_query[9..34]
    to_querystring
  end

  def make_request
    query_string = build_query
    result = RestClient.post @service_uri, query_string
    return result.body.split "\r"
  end

  def to_querystring(hsh = @post_params)
    hsh.map { |pair| "#{URI::encode pair.first.to_s}=#{URI::encode pair.last.to_s}" }.join('&')
  end

  def save_post response
    {
      sessionid: 1,
      logurl: 2,
      vText8: 3,
      vText7: 4,
      vText6: 5,
      vText5: 6,
      vText4: 7,
      vText3: 8,
      vText2: 9,
      prevref: 10,
      emotionalhistory: 12,
      ttsLocMP3: 13,
      ttsLocTXT: 14,
      ttsLocTXT3: 15,
      ttsText: 16,
      lineRef: 17,
      lineURL: 18,
      linePOST: 19,
      lineChoices: 20,
      lineChoicesAbbrev: 21,
      typingData: 22,
      divert: 23
    }.each_pair do |key, value|
      @post_params[key] = response[value]
    end
  end
end

class CleverBotResponse
  attr_reader :question, :answer

  def initialize response_data
    @question = response_data[8]
    @answer   = response_data[16]
  end
end
