class User < ApplicationRecord
  has_secure_password

  before_create :generate_uuid

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin user] }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!
  end

  def reset_password_token_valid?
    reset_password_sent_at && reset_password_sent_at > 2.hours.ago
  end

  def clear_reset_password_token!
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    save!
  end

  private

  def generate_uuid
    self.id = SecureRandom.uuid if id.blank?
  end
end
