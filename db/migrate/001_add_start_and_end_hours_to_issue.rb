class AddStartAndEndHoursToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :starting_hours, :string, default: '09:00:00'
    add_column :issues, :finishing_hours, :string, default: '18:00:00'

    add_column :issues, :ical_event_uid, :text
  end
end
