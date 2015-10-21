class Employee < ActiveRecord::Base
  before_validation :normalize_email
  validates :name, :email, presence: true
  # Gem 'validate'
  validates :email, email: true

  has_many :results
  has_many :answers, through: :results
  belongs_to :company
  has_and_belongs_to_many :company_surveys

  def self.to_csv
    attributes = %w(name email department position)
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << user.attributes.values_at(*attributes)
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
