def login(email, password)
  visit new_user_session_path
  fill_in('user[email]', with: email)
  fill_in('user[password]', with: password)
  click_on 'Login'
end

def set_company_admin(company, user)
  user.add_role :company_admin, company
end
