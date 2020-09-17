class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def index
    if params[:tag_id]
      @tag_list = Tag.all
      @tag = Tag.find(params[:tag_id])
      @posts = current_user.like_posts.page(params[:page]).per(9)
    else
      @tag_list = Tag.all
      @posts = current_user.like_posts.page(params[:page]).per(9)
    end
  end

  def create
    # @like = current_user.likes.new(post_id: params[:post_id])
    @like = Like.new(user_id: current_user.id, post_id: params[:post_id])
    @like.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def correct_user
      @like = current_user.likes.find_by(post_id: params[:id])
    end

end
