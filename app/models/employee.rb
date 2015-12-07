class Employee < ActiveRecord::Base
  before_validation :normalize_email
  validates :first_name, :last_name, :email, presence: true
  # Gem 'validate'
  validates :email, email: true

  has_many :results
  has_many :answers, through: :results
  belongs_to :office_location
  belongs_to :department, autosave: true
  has_and_belongs_to_many :company_surveys

  delegate :company, to: :department
  #delegate :country, :address, :city, to: :office_location

  ransacker :age, formatter: proc { |v| Date.today - v.to_i.year } do |parent|
    parent.table[:birthday]
  end

  def name
    self[:name] || [first_name, last_name].join(' ')
  end

  def self.to_csv
    attributes = %w(first_name last_name email position)
    CSV.generate(headers: true) do |csv|
      csv << [attributes, 'Dept. Name'].flatten
      all.each do |user|
        csv << user.attributes.values_at(*attributes).push(user.department.name)
      end
    end
  end

  def self.import(file, company)
    spreadsheet = Spreadsheet.new(file)
    spreadsheet.import(self.model_name.name, company_id: company.id)
  end

  private

  def normalize_email
    self.email = normalize(email)
  end

  def normalize(text)
    text.mb_chars.downcase.strip.wrapped_string
  end
end
