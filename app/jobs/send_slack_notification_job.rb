class SendSlackNotificationJob < ApplicationJob
  def perform(message)
    return unless ENV['SLACK_WEBHOOK_URL'].present?

    HTTParty.post(
      ENV['SLACK_WEBHOOK_URL'],
      body: {"text": message}.to_json,
      headers: {'Content-Type' => 'application/json' }
    )
  end
end