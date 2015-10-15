module CompaniesHelper
  def users_list(company)
    company.users.pluck(:name).join(', ')
  end

  def user_name_with_email(user)
    "#{user.name} (#{mail_to user.email})"
  end

  def admin_select(company, company_admin)
    select_tag :admin,
               options_for_select(@company.users.collect { |a| [a.name, a.id] }, company_admin.id),
               disabled: !current_user.is_admin_for?(@company),
               class: 'selectable'
  end
end