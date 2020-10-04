class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to @post
    else
      render "posts/show"
    end
  end



  def destroy
    @comment.destroy
    flash[:notice] = "#{@comment.content}を削除しました"
    redirect_back(fallback_location: root_path)
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def correct_user
      # @comment = current_user.comments.find_by(id: params[:id])
      @comment = Comment.find(params[:id])
      redirect_to root_url, notice: "権限がありません" unless @comment.user_id == current_user.id || current_user.admin?
    end
end
