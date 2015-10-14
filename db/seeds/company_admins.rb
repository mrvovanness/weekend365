puts "Creating admins for companies"
Company.find_each do |company|
  next if company.roles.count > 0
  user = company.users.first
  user.add_role :company_admin, company
end
