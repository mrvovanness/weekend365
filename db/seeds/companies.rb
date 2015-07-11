# to run this: rake db:seed:companies
puts 'Creating fake companies'
100.times do
  Company.create!(name: FFaker::Company.name)
end
puts "Number of fake companies created - #{ Company.count }"
