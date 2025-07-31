module Auth::Operation
  class ResetPassword < Trailblazer::Operation
    step :contract_build
    step :contract_validate
    step :find_user_by_token
    step :validate_token_expiry
    step :update_password
    step :clear_reset_token

    def contract_build(ctx, **)
      ctx[:contract] = Auth::Contract::ResetPassword.new
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

    def update_password(ctx, user:, params:, **)
      if user.update(password: params[:password])
        true
      else
        ctx[:errors] = user.errors.as_json
        false
      end
    end

    def clear_reset_token(ctx, user:, **)
      user.clear_reset_password_token!
      true
    end
  end
end