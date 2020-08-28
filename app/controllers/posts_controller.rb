class PostsController < ApplicationController
  before_action :find_params, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :destroy, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @user = @post.user
    @comments = @post.comments.all
    @comment = Comment.new
  end


  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to posts_path, notice: "#{@post.title}を投稿しました"
    else 
      render :new
    end
    
  end

  def edit
  end

  def update
    if @post.update!(post_params)
      redirect_to posts_url, notice: "#{@post.title}を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "#{@post.title}を削除しました"
  end

  private

    def post_params
      params.require(:post).permit(:title, :image, :staff, :episode, :favorite_scene, :broadcast, :cast)
    end

    def find_params
      @post = Post.find(params[:id])
    end

    def correct_user
      @post = Post.find_by(id: params[:id])
      redirect_to root_path, notice: "権限がありません" unless @post.user_id == current_user.id || current_user.admin?
    end
end
