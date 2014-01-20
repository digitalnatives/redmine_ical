class AddStartAndEndHoursToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :starting_hours, :string, default: '06:00:00'
    add_column :issues, :finishing_hours, :string, default: '22:00:00'
  end
end
