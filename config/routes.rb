Rails.application.routes.draw do
  post '/search', to: 'search#new'
end
