Rails.configuration.to_prepare do
  require_dependency 'ical_view_hook_listener'

  Issue.class_eval do
    safe_attributes 'starting_hours', 'finishing_hours'

    serialize :starting_hours, Tod::TimeOfDay
    serialize :finishing_hours, Tod::TimeOfDay
  end

end

Redmine::Plugin.register :redmine_ical do
  name 'Redmine Ical plugin'
  author 'Digital Natives'
  description 'This is a plugon for redmine that generates ical for the specified trackers.'
  version '0.0.1'
  url 'tba'
  author_url 'tba'
end
