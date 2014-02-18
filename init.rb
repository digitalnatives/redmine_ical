Rails.configuration.to_prepare do
  require_dependency 'ical_view_hook_listener'

  Issue.add_hidden_attribute "ical_event_uid"

  JournalDetail.class_eval do
    private
    alias_method :old_normalize, :normalize
    def normalize(v)
      v.is_a?(Tod::TimeOfDay) ? v.to_s : old_normalize(v)
    end
  end

  Issue.class_eval do
    safe_attributes 'starting_hours', 'finishing_hours'

    serialize :starting_hours, Tod::TimeOfDay
    serialize :finishing_hours, Tod::TimeOfDay

    validates :starting_hours, :finishing_hours,
              presence: true, if: :needs_ical_event?

    delegate :icalendar, :save_icalendar!, to: :project

    after_create :create_icalendar_event!, if: :needs_ical_event?
    after_update :update_icalendar_event!, if: :needs_ical_event?
    after_update :destroy_icalendar_event!, if: :needed_ical_event?
    after_destroy :destroy_icalendar_event!, if: :needs_ical_event?

    validate :hours_format, if: :needs_ical_event?

    scope :ical_events, -> do
      where("tracker_id IN (?)", Setting.plugin_redmine_ical['trackers'])
    end

    def hours_format
      [:starting_hours, :finishing_hours].each do |hours|
        begin
          Tod::TimeOfDay.parse(send(hours))
        rescue ArgumentError => _
          errors.add(hours, :invalid)
        end
      end
    end

    def ical_start_date
      start_day = start_date || Date.today
      start_day.at(starting_hours).to_datetime
    end

    def ical_end_date
      finish_day = due_date || start_date || Date.today
      finish_day.at(finishing_hours).to_datetime
    end

    def needs_ical_event?
      Issue.needs_ical_event_for_tracker?(tracker.id)
    end

    def needed_ical_event?
      !needs_ical_event? && Issue.needs_ical_event_for_tracker?(tracker_id_was)
    end

    def self.needs_ical_event_for_tracker?(tracker_id)
      Setting.plugin_redmine_ical['trackers'].include?(tracker_id.to_s)
    end

    def ical_event
      icalendar.find_event(ical_event_uid)
    end

    def up_to_date_event
      event             = Icalendar::Event.new
      event.start       = ical_start_date
      event.end         = ical_end_date
      event.summary     = subject
      event.description = description
      event
    end

    def up_to_date_event!
      event = up_to_date_event
      (update_column :ical_event_uid, event.uid) && event
    end

    private

    def create_icalendar_event!
      update_icalendar!(up_to_date_event)
    end

    def update_icalendar_event!
      icalendar.remove_event(ical_event)
      update_icalendar!(up_to_date_event)
    end

    def destroy_icalendar_event!
      icalendar.remove_event(ical_event)
      save_icalendar!
    end

    def update_icalendar!(event)
      icalendar.add_event(event)

      update_column :ical_event_uid, event.uid
      save_icalendar!
    end
  end

  Project.class_eval do
    has_many :ical_download_tokens

    def self.calendars_folder_name
      "calendars"
    end

    def cal_filename
      "#{Project.calendars_folder_name}/#{identifier}.ics"
    end

    def has_ical_file?
      File.file?(cal_filename)
    end

    def valid_ical_tokens
      ical_download_tokens.valid
    end

    def ical_download_token!
      save_icalendar! unless has_ical_file?
      ical_download_tokens.first_or_create.token
    end

    def save_icalendar!
      Project.create_calendars_folder_name!
      File.open(cal_filename, 'w+') { |f| f.write icalendar.to_ical }
    end

    def self.create_calendars_folder_name!
      unless File.directory?(Project.calendars_folder_name)
        Dir.mkdir(Project.calendars_folder_name)
      end
    end

    def icalendar
      @ical ||= begin
                  Icalendar.parse(File.open(cal_filename)).first || raise
                rescue
                  new_calendar
                end
      @ical
    end

    def new_calendar
      calendar = Icalendar::Calendar.new
      issues.ical_events.each do |issue|
        calendar.add_event(issue.up_to_date_event!)
      end
      calendar
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
  settings default: { trackers: nil }, partial: 'settings/rm_ical_settings'
end
