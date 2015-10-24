class UnsubscribeUserFromMailingListJob
  @queue = :subscribe

  def self.perform(user)
    begin
      member_id = Digest::MD5.hexdigest(user.email)
      gb = Gibbon::Request.new
      result = gb.lists(ENV["MAILCHIMP_LIST_ID"]).members(member_id).update(
        body: {
          status: "unsubscribed"
        }
      )
      Rails.logger.info("User #{user.email} was successfully unsubscribed from our mailing list")
    rescue Gibbon::MailChimpError => e
      Rails.logger.error("Subscription failed with code #{e.status_code}, title: #{e.title}, body: #{e.body}")
    end
  end
end