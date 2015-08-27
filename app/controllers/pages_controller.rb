class PagesController < ApplicationController
  def about
    @about_fake = FFaker::Lorem.paragraphs
    render layout: 'devise'
  end

end
