module Auth::Contract
  class ResetPassword
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :token, :string
    attribute :password, :string
    attribute :confirm_password, :string

    validates :token, presence: true
    validates :password, presence: true, length: { minimum: 6 }
    validates :confirm_password, presence: true
    validate :passwords_match

    private

    def passwords_match
      return unless password && confirm_password
      
      errors.add(:confirm_password, 'Las contraseñas no coinciden') if password != confirm_password
    end
  end
end