module CompaniesHelper
  def users_list(company)
    company.users.pluck(:name).join(', ')
  end
end