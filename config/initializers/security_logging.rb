
security_log_path = Rails.root.join('log', 'security.log')
SECURITY_LOGGER = ActiveSupport::Logger.new(security_log_path, 10, 1024 * 1024)
SECURITY_LOGGER.formatter = proc do |severity, datetime, _progname, msg|
  "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
end

Warden::Manager.before_failure do |env, opts|
  request = ActionDispatch::Request.new(env)
  if opts[:action] == 'unauthenticated' && opts[:scope] == :user && request.params['user']
    log_message = {
      event: 'failed_login_attempt',
      email: request.params.dig('user', 'email'),
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      path: request.path,
      warden_message: opts[:message]
    }.to_json
    SECURITY_LOGGER.warn(log_message)
  end
end
