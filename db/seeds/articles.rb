# rake db:seed:articles

puts "Creating default articles"

about_us = Article.find_or_create_by(title: 'About') do |a|
  a.body_markdown = '##coming soon'
end

agreement = Article.find_or_create_by(title: 'User Agreement') do |a|
  a.body_markdown = '##coming soon'
end

privacy_policy = Article.find_or_create_by(title: 'Privacy Policy') do |a|
  a.body_markdown = '##coming soon'
end

puts "Created: #{ Article.all.map(&:title).join(', ')}"
