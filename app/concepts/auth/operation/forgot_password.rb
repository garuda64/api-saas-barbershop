module Auth::Operation
  class ForgotPassword < Trailblazer::Operation
    step :contract_build
    step :contract_validate
    step :find_user
    step :generate_reset_token
    step :send_reset_email

    def contract_build(ctx, **)
      ctx[:contract] = Auth::Contract::ForgotPassword.new
    end

    def contract_validate(ctx, params:, **)
      ctx[:contract].validate(params)
    end

    def find_user(ctx, params:, **)
      user = User.find_by(email: params[:email])
      if user
        ctx[:user] = user
        true
      else
        # Por seguridad, no revelamos si el email existe o no
        true
      end
    end

    def generate_reset_token(ctx, user: nil, **)
      return true unless user
      
      user.generate_reset_password_token!
      ctx[:reset_token] = user.reset_password_token
      true
    end

    def send_reset_email(ctx, user: nil, reset_token: nil, **)
      return true unless user && reset_token
      
      # Aquí normalmente enviarías un email
      # Por ahora solo simulamos el envío
      Rails.logger.info "Reset password email sent to #{user.email} with token: #{reset_token}"
      true
    end
  end
end