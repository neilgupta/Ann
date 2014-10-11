class BrainsController < ApplicationController

  # Streaming set of instructions for CNS to disseminate
  def instructions
    brain = Brain.where("lower(address) = ?", params[:address].downcase).first
    render json: brain.fetch_instructions, root: false
  end

  # Endpoint for pushing sensory data to brain
  def senses
    brain = Brain.where("lower(address) = ?", params[:address].downcase).first

    sensor = Sensor.where("lower(address) = ? and brain_id = ?", params[:sensor_addr].downcase, brain.id).first
    params[:payload] &&= {message: params[:payload]} # This is a really stupid hack to work around my own stupidity but I'm far too tired to care
    sensor.save_data(params[:payload]) if sensor && params[:payload]

    head :ok # return empty 200 response
  end
end
