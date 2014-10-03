class BrainsController < ApplicationController
  include ActionController::Live

  # Streaming set of instructions for CNS to disseminate
  def instructions
    response.headers['Content-Type'] = 'text/event-stream'
    response.stream.write ' '

    brain = Brain.find_by_address(params[:address])

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

  # Endpoint for pushing sensory data to brain
  def senses
    brain = Brain.find_by_address(params[:address])

    inputs = params[:inputs]
    inputs.each do |input|
      sensor = Sensor.where("address = ? and brain_id = ?", input.address, brain.id).first
      next unless sensor

      sensor.save_data(input.payload) if input.payload
    end

    head :ok # return empty 200 response
  end
end
