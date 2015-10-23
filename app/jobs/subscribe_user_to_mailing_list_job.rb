class SubscribeUserToMailingListJob
  @queue = :subscribe

  def self.perform(user)
    begin
      member_id = Digest::MD5.hexdigest(user.email.downcase)
      gb = Gibbon::Request.new
      result = gb.lists(ENV["MAILCHIMP_LIST_ID"]).members(member_id).upsert(
        body: {
          email_address: user.email,
          status: "subscribed",
          merge_fields: { USERNAME: user.name, COMPANY: user.company.name }
        }
      )
      Rails.logger.info("User #{user.email} was successfully added to mailing list")
    rescue Gibbon::MailChimpError => e
      Rails.logger.error("Subscription failed with code #{e.status_code}, title: #{e.title}, body: #{e.body}")
    end
  end
end
