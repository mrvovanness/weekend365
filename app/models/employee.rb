class Employee < ActiveRecord::Base
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
    CSV.foreach(file.path, headers: true) do |row|
      company.employees.find_or_create_by!(row.to_hash)
    end
  end
end
