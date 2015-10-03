# rake db:seed:articles

puts "Creating default articles"

article = Article.find_or_create_by(title: 'Email Promo') do |article|
  article.body = "Check out the <a href='#'style='color:#F19926'>Weekend blog</a> to get hints"\
    " on how to improve your work satisfaction transforming your company into a better place."
end

puts 'Done!'
