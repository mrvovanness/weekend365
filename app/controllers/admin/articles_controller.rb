class Admin::ArticlesController < Admin::BaseController

  def index
    @articles = Article.includes(:translations).order(updated_at: :desc)
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.friendly.find(params[:id])
  end

  def update
    @article = Article.friendly.find(params[:id])
    @article.update!(article_params)
    respond_with :admin, @article
  end

  private

  def article_params
    params.require(:article).permit(:body_markdown)
  end
end
