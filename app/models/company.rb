class Company < ActiveRecord::Base
  resourcify
  validates :name, presence: true
  belongs_to :company_field
  has_many :employees, dependent: :destroy
  has_many :company_surveys, dependent: :destroy
  has_many :results, through: :employees
  has_many :users, inverse_of: :company, dependent: :destroy

  def change_admin(user_id)
    company_admin = User.with_role(:company_admin, self).first
    if company_admin.id != user_id
      company_admin.remove_role(:company_admin, self)
      new_admin = User.find(user_id)
      new_admin.add_role(:company_admin, self)
    end
  end

  def timezone
    unless @time_zone
      tz_id = read_attribute(:timezone)
      as_name = ActiveSupport::TimeZone::MAPPING.select do |_,v|
        v == tz_id
      end.sort_by do |k,v|
        v.ends_with?(k) ? 0 : 1
      end.first.try(:first)
      value = as_name || tz_id
      time_zone = value && ActiveSupport::TimeZone[value]
    end
    time_zone.name
  end

  def timezone=(value)
    tz_id = value.respond_to?(:tzinfo) && value.tzinfo.name || nil
    tz_id ||= TZInfo::Timezone.get(ActiveSupport::TimeZone::MAPPING[value.to_s] || value.to_s).identifier
    write_attribute(:timezone, tz_id)
  end
end
