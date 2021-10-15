class JsonWebToken
  class << self
    HMAC_SECRET = "df09dcea68750666d1632f4cb6dc40856b003ab3ea111a8faa96ada57235c4d62998e40223455ab2dd6a5c861ad608d107632cef25b6f1a3454a3807ae8567c3"

    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp
      JWT.encode(payload, HMAC_SECRET)
    end

    def decode(token)
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body

    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end
  end
end
