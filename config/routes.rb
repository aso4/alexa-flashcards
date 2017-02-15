Rails.application.routes.draw do
  #root 'welcome#index'

  get 'favicon', to: "welcome#favicon"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/analytics', to: 'alexa#analytics' #controller name method name
  get '/oauth2callback', to: 'alexa#callback' #controller name method name
  get '/', to: 'alexa#redirect'
  post '/', to: 'alexa#index'
end
