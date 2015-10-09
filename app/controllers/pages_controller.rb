class PagesController < ApplicationController
  layout 'devise'

  def show
    @article = Article.friendly.find(params[:id])
  end

end
