class JwtService
  SECRET_KEY = Rails.application.secret_key_base || 'your-secret-key'
  ALGORITHM = 'HS256'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    raise StandardError, "Invalid token: #{e.message}"
  end

  def self.generate_tokens(user)
    access_payload = { user_id: user.id, type: 'access' }
    refresh_payload = { user_id: user.id, type: 'refresh' }

    {
      access_token: encode(access_payload, 1.hour.from_now),
      refresh_token: encode(refresh_payload, 7.days.from_now)
    }
  end

  def self.verify_token(token, type = 'access')
    decoded = decode(token)
    return false unless decoded[:type] == type
    
    User.find(decoded[:user_id])
  rescue StandardError
    false
  end
end