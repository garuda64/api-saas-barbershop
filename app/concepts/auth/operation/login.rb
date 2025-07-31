module Auth::Operation
  class Login < Trailblazer::Operation
    step :contract_build
    step :contract_validate
    step :find_user
    step :authenticate_user
    step :generate_tokens

    def contract_build(ctx, **)
      ctx[:contract] = Auth::Contract::Login.new
    end

    def contract_validate(ctx, params:, **)
      ctx[:contract].assign_attributes(params)
      if ctx[:contract].valid?
        true
      else
        ctx[:errors] = ctx[:contract].errors.to_hash
        false
      end
    end

    def find_user(ctx, params:, **)
      user = User.find_by(email: params[:email])
      if user
        ctx[:user] = user
        true
      else
        ctx[:errors] = { email: ['Usuario no encontrado'] }
        false
      end
    end

    def authenticate_user(ctx, user:, params:, **)
      if user.authenticate(params[:password])
        true
      else
        ctx[:errors] = { password: ['Contraseña incorrecta'] }
        false
      end
    end

    def generate_tokens(ctx, user:, **)
      tokens = JwtService.generate_tokens(user)
      ctx[:access_token] = tokens[:access_token]
      ctx[:refresh_token] = tokens[:refresh_token]
      true
    end
  end
end