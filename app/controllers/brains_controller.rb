class BrainsController < ApplicationController

  # Streaming set of instructions for CNS to disseminate
  def instructions
    brain = Brain.find_by_address(params[:address])
    render json: brain.fetch_instructions, root: false
  end

  # Endpoint for pushing sensory data to brain
  def senses
    brain = Brain.find_by_address(params[:address])

    sensor = Sensor.where("address = ? and brain_id = ?", params[:sensor_addr], brain.id).first
    sensor.save_data(params[:payload]) if sensor && params[:payload]

    head :ok # return empty 200 response
  end
end
