class BrainsController < ApplicationController

  # Streaming set of instructions for CNS to disseminate
  def instructions
    brain = Brain.find_by_address(params[:address])
    render json: brain.fetch_instructions, root: false
  end

  # Endpoint for pushing sensory data to brain
  def senses
    brain = Brain.find_by_address(params[:address])

    inputs = params[:inputs]
    inputs.each do |input|
      sensor = Sensor.where("address = ? and brain_id = ?", input['address'], brain.id).first
      next unless sensor

      sensor.save_data(input['payload']) if input['payload']
    end

    head :ok # return empty 200 response
  end
end
