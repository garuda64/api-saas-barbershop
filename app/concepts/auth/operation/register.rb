module Auth::Operation
  class Register < Trailblazer::Operation
    step :contract_build
    step :contract_validate
    step :check_email_uniqueness
    step :create_user
    step :generate_tokens

    def contract_build(ctx, **)
      ctx[:contract] = Auth::Contract::Register.new
    end

    def contract_validate(ctx, params:, **)
      ctx[:contract].assign_attributes(params)
      result = ctx[:contract].valid?
      ctx[:errors] = ctx[:contract].errors.messages unless result
      result
    end

    def check_email_uniqueness(ctx, params:, **)
      if User.exists?(email: params[:email])
        ctx[:errors] = { email: ['El email ya está registrado'] }
        false
      else
        true
      end
    end

    def create_user(ctx, params:, **)
      user_params = params.except(:confirm_password, :confirmPassword)
      user = User.new(user_params)
      
      if user.save
        ctx[:user] = user
        true
      else
        ctx[:errors] = user.errors.as_json
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