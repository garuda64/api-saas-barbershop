class Auth::Contract::Register
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :name, :string
  attribute :email, :string
  attribute :password, :string
  attribute :confirm_password, :string
  attribute :confirmPassword, :string
  attribute :phone, :string
  attribute :role, :string

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, presence: true, inclusion: { in: %w[admin user] }
  
  validate :passwords_match

  # Método para normalizar confirm_password
  def assign_attributes(attributes)
    # Si viene confirmPassword, lo asignamos también a confirm_password
    if attributes[:confirmPassword] && !attributes[:confirm_password]
      attributes = attributes.dup
      attributes[:confirm_password] = attributes[:confirmPassword]
    end
    super(attributes)
  end

  private

  def passwords_match
    return unless password && confirm_password
    
    errors.add(:confirm_password, "doesn't match password") if password != confirm_password
  end
end