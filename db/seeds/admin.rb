# Create admin user
puts 'creating signup'
signup = Signup.new
signup.name = 'Gustavo'
signup.email = 'weekend@mail.com'
signup.password = 'bigsecret'
signup.company_name = 'Brazilian Tunes'
signup.country = 'Brazil'
signup.save

user = User.find_by(name: 'Gustavo')
user.confirmed_at = DateTime.current - 1.day
user.save
user.add_role :admin

puts "User admin? - #{user.has_role? :admin}, with company #{user.company.name}"
