Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/flashcards', to: 'alexa#dd' #controller name method name
  post '/', to: 'alexa#index'
end
