# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :projects do
  get 'ical', :to => 'project_icals#show'
end
