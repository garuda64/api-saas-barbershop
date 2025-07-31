module Auth::Contract
  class ValidateResetToken
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :token, :string

    validates :token, presence: true
  end
end