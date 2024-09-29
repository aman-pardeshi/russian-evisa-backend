class ApiKeyHandler
  def self.encoded_api_key(user_id)
    payload = { exp: 4.week.from_now.to_i, user_id: user_id }
    api_key = JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode_api_key(api_key)
    JWT.decode(api_key, Rails.application.credentials.secret_key_base)
  end
end