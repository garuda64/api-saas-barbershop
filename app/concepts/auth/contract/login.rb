module Auth::Contract
  class Login
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :email, :string
    attribute :password, :string

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true
  end
end