class IcalDownloadToken < ActiveRecord::Base
  attr_accessible :expires_at, :project
  before_create :generate_token

  belongs_to :project

  validates :project_id, presence: true

  scope :valid, -> { where("expires_at >= ?", Time.now) }

  def expired?
    expires_at < Time.now
  end

  def generate_token
    self.token = SecureRandom.uuid.delete('-')
    self.expires_at = 1.day.from_now
  end
end
