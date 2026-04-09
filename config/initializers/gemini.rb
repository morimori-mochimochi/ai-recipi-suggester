Gemini.configure do |config|
  config.access_token = Rails.application.credentials.google_ai[:api_keys]
end