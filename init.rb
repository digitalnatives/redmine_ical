Rails.configuration.to_prepare do
  require_dependency 'ical_view_hook_listener'

  Issue.class_eval do
    safe_attributes 'starting_hours', 'finishing_hours'

    serialize :starting_hours, Tod::TimeOfDay
    serialize :finishing_hours, Tod::TimeOfDay

    validates :starting_hours, :finishing_hours,
              presence: true, if: :cal_hours_should_be_validated?

    delegate :icalendar, :save_icalendar!, to: :project

    after_create :create_event_for_icalendar!, if: :should_generate_ical?

    def ical_start_date
      start_day = start_date || Date.today
      start_day.at(starting_hours).to_datetime
    end

    def ical_end_date
      finish_day = due_date || start_date || Date.today
      finish_day.at(finishing_hours).to_datetime
    end

    def create_event_for_icalendar!
      event = Icalendar::Event.new
      event.start       = ical_start_date
      event.end         = ical_end_date
      event.summary     = description
      event.description = subject
      icalendar.add_event(event)

      update_column :ical_event_uid, event.uid
      save_icalendar!
    end

    private

    def should_generate_ical?
      true
    end

    def cal_hours_should_be_validated?
      true
    end
  end

  Project.class_eval do
    def cal_filename
      "calendars/#{identifier}.ics"
    end

    def save_icalendar!
      File.open(cal_filename, 'w+') { |f| f.write icalendar.to_ical }
    end

    def icalendar

      @ical ||= begin
                  Icalendar.parse(File.open(cal_filename)).first || Icalendar::Calendar.new
                rescue
                  Icalendar::Calendar.new
                end
      @ical
    end
  end

end

Redmine::Plugin.register :redmine_ical do
  name 'Redmine Ical plugin'
  author 'Digital Natives'
  description 'This is a plugin for redmine that generates ical for the specified trackers.'
  version '0.0.1'
  url 'tba'
  author_url 'tba'
end
