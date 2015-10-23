class Company < ActiveRecord::Base
  resourcify
  validates :name, presence: true
  belongs_to :company_field
  has_many :employees, dependent: :destroy
  has_many :company_surveys, dependent: :destroy
  has_many :results, through: :employees
  has_many :users, inverse_of: :company, dependent: :destroy

  after_update :check_subscription

  def admin
    User.with_role(:company_admin, self).first
  end

  def change_admin(user_id)
    company_admin = admin
    if company_admin.id != user_id
      company_admin.remove_role(:company_admin, self)
      new_admin = User.find(user_id)
      new_admin.add_role(:company_admin, self)
      if subscribed
        UnsubscribeUserFromMailingListJob.perform(company_admin)
        SubscribeUserToMailingListJob.perform(new_admin)
      end
    end
  end

  def timezone
    tz_id = read_attribute(:timezone)
    as_name = ActiveSupport::TimeZone::MAPPING.select do |_,v|
      v == tz_id
    end.sort_by do |k,v|
      v.ends_with?(k) ? 0 : 1
    end.first.try(:first)
    value = as_name || tz_id
    time_zone = value && ActiveSupport::TimeZone[value]
    time_zone.name
  end

  def timezone=(value)
    tz_id = value.respond_to?(:tzinfo) && value.tzinfo.name || nil
    tz_id ||= TZInfo::Timezone.get(ActiveSupport::TimeZone::MAPPING[value.to_s] || value.to_s).identifier
    write_attribute(:timezone, tz_id)
  end

  private

  def check_subscription
    if subscribed
      SubscribeUserToMailingListJob.perform(admin)
    else
      UnsubscribeUserFromMailingListJob.perform(admin)
    end
  end
end
