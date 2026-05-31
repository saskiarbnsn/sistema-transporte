module ApplicationHelper
  def google_maps_api_key
    ENV["GOOGLE_MAPS_API_KEY"].presence ||
      Rails.application.credentials.dig(:google, :maps_api_key).presence
  rescue StandardError
    ENV["GOOGLE_MAPS_API_KEY"].presence
  end
end
