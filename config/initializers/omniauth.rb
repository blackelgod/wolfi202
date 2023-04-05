Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord, ENV["CLIENT_ID"], ENV["CLIENT_SECRET"], scope: 'email identify'
  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }
end
