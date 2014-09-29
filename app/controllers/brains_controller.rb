class BrainsController < ApplicationController
  include ActionController::Live

  def instructions
    response.headers['Content-Type'] = 'text/event-stream'
    response.stream.write ' '

    brain = Brain.find(params[:id])

    loop do
      # Write any instructions waiting to be sent
      response.stream.write brain.fetch_instructions
      # Send instructions again in 3 seconds
      sleep 3
    end
  rescue Exception => e
    response.stream.write({errors: e.message}.to_json)
    raise e
  ensure
    response.stream.close
  end
end
