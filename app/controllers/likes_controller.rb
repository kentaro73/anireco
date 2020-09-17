class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    # @like = current_user.likes.new(post_id: params[:post_id])
    @like = Like.new(user_id: current_user.id, post_id: params[:post_id])
    @like.save
    redirect_to posts_path
  end

  def destroy
    @like.destroy
    redirect_to posts_path
  end

  private

    def correct_user
      @like = current_user.likes.find_by(post_id: params[:id])
    end

end
