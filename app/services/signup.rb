class Signup
  include Virtus.model
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_reader :user
  attr_reader :company

  attribute :name, String
  attribute :email, String
  attribute :password, String
  attribute :company_name, String
  attribute :country, String

  validates :email, :name, :company_name, :password, :country, presence: true
  validates :password, length: { minimum: 8 }
  validates :name, :company_name, length: { minimum: 2 }

  def persisted?
    false
  end

  def save
    return false unless valid?
    delegate_attibutes_for_company
    delegate_attributes_for_user

    delegate_errors_for_user

    if !errors.any?
      persist!
      true
    else
      false
    end
  end

  private

  def delegate_attributes_for_user
    @user = @company.users.new do |user|
      user.name = name
      user.email = email
      user.password = password
    end
  end

  def delegate_attibutes_for_company
    @company = Company.new do |company|
      company.name = company_name
      company.country = country
    end
  end

  def delegate_errors_for_user
    errors.add(:email, @user.errors[:email].first) if @user.errors[:email].present?
  end

  def persist!
    @company.save!
  end
end
