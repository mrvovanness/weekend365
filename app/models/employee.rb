class Employee < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  # Как вариант использовать https://github.com/kaize/validates и тогда просто "email: true"
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ }

  belongs_to :company

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
