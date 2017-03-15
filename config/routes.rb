# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :projects do
    get 'gage'      				=> 'gage#index'
    get 'gage/:flagMonth'      		=> 'gage#index'
    get 'gage/:flagMonth/:flagHour' => 'gage#index'
    get 'gage/list' 				=> 'gage#list'
    get 'gage/data' 				=> 'gage#data'
    get 'gage/data/:flagMonth' 		=> 'gage#data'
    get 'gage/data.json/:flagMonth' => 'gage#data'
  end
end