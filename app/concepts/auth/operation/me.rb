module Auth::Operation
  class Me < Trailblazer::Operation
    step :authenticate_user

    def authenticate_user(ctx, current_user:, **)
      if current_user
        ctx[:user] = current_user
        true
      else
        ctx[:errors] = { auth: ['Token inválido o expirado'] }
        false
      end
    end
  end
end