class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:index, :destroy]


  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.all.order(created_at: :desc)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "ユーザー「#{@user.name}」を削除しました"
  end

  private

    def require_admin
      redirect_to root_path, notice: "権限がありません" unless current_user.admin?
    end

end
