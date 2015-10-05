class PagesController < ApplicationController
  layout 'home'

  def show
    @article = Article.friendly.find(params[:id])
  end

end
