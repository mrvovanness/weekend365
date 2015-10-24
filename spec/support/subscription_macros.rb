def check_status(email)
  member_id = Digest::MD5.hexdigest(email.downcase)
  gb = Gibbon::Request.new
  members_data = gb.lists(ENV['MAILCHIMP_LIST_ID']).members.retrieve
  subscriber = {}
  members_data['members'].each do |m|
    if m['id'] == member_id
      subscriber = m
      break
    end
  end
  subscriber.has_key?('status') ? subscriber['status'] : 'none'
end

def subscribe(email)
  member_id = Digest::MD5.hexdigest(email.downcase)
  gb = Gibbon::Request.new
  gb.lists(ENV["MAILCHIMP_LIST_ID"]).members(member_id).upsert(
    body: {
      email_address: user.email,
      status: "subscribed",
      merge_fields: { USERNAME: user.name, COMPANY: user.company.name }
    }
  )
end

def unsubscribe(email)
  return if check_status(email) == 'none'
  member_id = Digest::MD5.hexdigest(email.downcase)
  gb = Gibbon::Request.new
  gb.lists(ENV["MAILCHIMP_LIST_ID"]).members(member_id).update(
    body: {
      status: "unsubscribed"
    }
  )
end
