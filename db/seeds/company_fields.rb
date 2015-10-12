# to run type in: rake db:seed:company_fields
puts 'Creating company fields'

def find_japan_translation(line_number)
  IO.readlines('db/seeds/fields_list.ja.txt')[line_number].delete("\n")
end

def find_portuguese_translation(line_number)
  IO.readlines('db/seeds/fields_list.pt.txt')[line_number].delete("\n")
end

file = File.open('db/seeds/fields_list.txt')

file.each_with_index do |line, index|
  I18n.locale = :en
  field = CompanyField.find_or_create_by(name: line.delete("\n"))

  I18n.locale = :ja
  field.update_attribute(:name, find_japan_translation(index.to_i))

  I18n.locale = :pt
  field.update_attribute(:name, find_portuguese_translation(index.to_i))
end

file.close

puts "Created #{CompanyField.count} company fields"