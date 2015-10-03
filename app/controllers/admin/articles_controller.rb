class Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!, :check_access

  def index
    @articles = Article.order(updated_at: :desc)
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)
    respond_with :admin, @article
  end

  private

  def check_access
    if current_user.is_usual?
    redirect_to dashboard_index_path and return
    end
  end

  def article_params
    params.require(:article).permit(:body)
  end
end
