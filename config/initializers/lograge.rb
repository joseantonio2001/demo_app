Rails.application.configure do
  if config.respond_to?(:lograge)
    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      {
        request_id: event.payload[:request_id],
        remote_ip: event.payload[:remote_ip],
        user_id: event.payload[:user_id]
      }
    end
  end
end
