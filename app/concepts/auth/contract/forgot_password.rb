module Auth::Contract
  class ForgotPassword
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :email, :string

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  end
end