# rake db:seed:articles

puts "Creating default articles"

about_us = Article.find_or_create_by(title: 'About') do |a|
  a.body_markdown = '##coming soon'
end

agreement = Article.find_or_create_by(title: 'User Agreement') do |a|
  a.body_markdown = '##coming soon'
end

privacy_policy = Article.find_or_create_by(title: 'Privacy Policy') do |a|
  a.body_markdown = IO.read('db/seeds/privacy-policy.md')
end

privacy_policy = Article.find_or_create_by(title: 'Advertisement') do |a|
  a.body_markdown = IO.read('db/seeds/advertisement.md')
end

privacy_policy = Article.find_or_create_by(title: 'Company culture') do |a|
  a.body_markdown = IO.read('db/seeds/company-culture.md')
end

privacy_policy = Article.find_or_create_by(title: 'Compare') do |a|
  a.body_markdown = IO.read('db/seeds/compare.md')
end

privacy_policy = Article.find_or_create_by(title: 'We help you') do |a|
  a.body_markdown = IO.read('db/seeds/we-help-you.md')
end

puts "Created: #{ Article.all.map(&:title).join(', ')}"
