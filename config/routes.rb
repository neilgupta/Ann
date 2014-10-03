Rails.application.routes.draw do
  get '/brains/:address/instructions', to: 'brains#instructions'
  post '/brains/:address/senses', to: 'brains#senses'
end
