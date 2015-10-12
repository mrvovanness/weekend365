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
end
