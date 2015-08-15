class CommentsController < ApplicationController

  http_basic_authenticate_with name: "whazz", password: "root",
                               only: :destroy

  def new
    @article = Article.find(params[:article_id])
  end

  def create
    @article = Article.find(params[:article_id])
    if @comment = @article.comments.create(comment_params)
      redirect_to article_path(@article)
    else
      render 'new'
    end


  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    @comment.destroy

    redirect_to article_path(@article)
  end

  private
    def comment_params
      #params[:comment][:commenter] = @current_user.name
      #params.require(:comment).permit(:body)

      comment_values = {
          :commenter => current_user.name,
          :body => params[:comment][:body]
      }
      return comment_values
    end
end
