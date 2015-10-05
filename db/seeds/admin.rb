# Create admin user
puts 'creating signup'

company = Company.new
company.name = 'Brazilian Tunes'
company.country = 'Brazil'
company.save

user = company.users.new
user.name = 'Gustavo'
user.email = 'weekend@mail.com'
user.skip_confirmation!
user.password = 'bigsecret'
user.save

user.add_role :admin

puts "User admin? - #{user.has_role? :admin}, with company #{user.company.name}"
