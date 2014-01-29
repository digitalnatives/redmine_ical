# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :projects do
  get 'ical.ics', as: :ical, :to => 'project_icals#show'
end
