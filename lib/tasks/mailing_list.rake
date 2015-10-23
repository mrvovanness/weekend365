desc 'Add all companies admins to Weekend mailing list'
task :add_to_mailing_list => :environment do
  Company.find_each do |company|
    SubscribeUserToMailingListJob.perform(company.admin)
  end
end
