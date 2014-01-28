class CreateIcalDownloadTokensTable < ActiveRecord::Migration
  def change
    create_table :ical_download_tokens do |t|
      t.integer :project_id, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :ical_download_tokens, [:token, :project_id], unique: true
  end
end
