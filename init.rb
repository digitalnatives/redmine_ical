Rails.configuration.to_prepare do
  require_dependency 'ical_view_hook_listener'

  Issue.class_eval do
    safe_attributes 'starting_hours', 'finishing_hours'

    serialize :starting_hours, Tod::TimeOfDay
    serialize :finishing_hours, Tod::TimeOfDay

    validates :starting_hours, :finishing_hours,
              presence: true, if: :cal_hours_should_be_validated?

    def ical_start_date
      start_day = start_date || Date.today
      start_day.at starting_hours
    end

    def ical_end_date
      finish_day = due_date || start_date || Date.today
      finish_day.at finishing_hours
    end

    private

    def cal_hours_should_be_validated?
      true
    end

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
