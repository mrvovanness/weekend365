class Department < ActiveRecord::Base
  acts_as_nested_set
  attr_accessor :employees_count
  belongs_to :company
  belongs_to :parent, class_name: 'Department'
  has_many :employees, autosave: true

  validates :name, presence: true
  validates_uniqueness_of :code, scope: :company_id, allow_nil: true

  def self.to_csv
    attributes = %w(name code)
    CSV.generate(headers: true) do |csv|
      csv << [attributes, 'No. Of Employees'].flatten
      all.each do |department|
        csv << department.attributes.values_at(*attributes).push(department.employees_count)
      end
    end
  end

  def self.import(file, company)
    spreadsheet = Spreadsheet.new(file)
    spreadsheet.import(self.model_name.name, company_id: company.id)
  end

  def employees_count
    self.employees.count
  end
end
