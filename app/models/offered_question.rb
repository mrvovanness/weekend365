class OfferedQuestion < ActiveRecord::Base
  validates :title, :type, presence: true
  has_and_belongs_to_many :company_surveys
  has_many :answers, dependent: :destroy
end
