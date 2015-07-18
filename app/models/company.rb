class Company < ActiveRecord::Base
  validates :name, :field, presence: true
  belongs_to :user
  has_many :employees

  # create company field dropdown list in edit form
  def set_fields_list
    file = File.open('app/views/companies/fields_list.txt')
    options = []
    file.each do |line|
      options << line
    end
    options
  end
end
