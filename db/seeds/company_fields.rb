# to run type in: rake db:seed:company_fields
puts 'Creating company fields'
file = File.open('db/seeds/fields_list.txt')
file.each do |line|
  CompanyField.create!(name: line)
end
file.close
puts "Created #{CompanyField.count} company fields"
