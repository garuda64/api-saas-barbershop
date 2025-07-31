module Auth::Operation
  class ValidateResetToken < Trailblazer::Operation
    step :contract_build
    step :contract_validate
    step :find_user_by_token
    step :validate_token_expiry

    def contract_build(ctx, **)
      ctx[:contract] = Auth::Contract::ValidateResetToken.new
    end

    def contract_validate(ctx, params:, **)
      ctx[:contract].validate(params)
    end

    def find_user_by_token(ctx, params:, **)
      user = User.find_by(reset_password_token: params[:token])
      if user
        ctx[:user] = user
        true
      else
        ctx[:errors] = { token: ['Token inválido'] }
        false
      end
    end

    def validate_token_expiry(ctx, user:, **)
      if user.reset_password_token_valid?
        true
      else
        ctx[:errors] = { token: ['Token expirado'] }
        false
      end
    end
  end
end