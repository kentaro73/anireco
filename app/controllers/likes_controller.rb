class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    like = current_user.likes.new(post_id: params[:post_id])
    like.save
    redirect_to posts_path
  end

  def destroy
    # なぜか↓がnilになりlike.destroyでNoMethodErrorになる
    like = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
    like.destroy
    redirect_to posts_path
  end

end
