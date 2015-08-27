class HomeController < ApplicationController

  def index
  end

  def about_us
    @about_fake = FFaker::Lorem.paragraphs
    render layout: 'devise'
  end
end
