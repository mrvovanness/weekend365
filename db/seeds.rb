# Create admin user
puts 'creating user'
user = User.new
user.email = 'weekend365@mail.com'
user.password = 'bigsecret'
user.skip_confirmation!
user.save
user.add_role :admin
user.company = Company.create! name: 'Coca-Cola', field: 'foods'
puts "User admin? - #{user.has_role? :admin}, with company #{user.company.name}"
