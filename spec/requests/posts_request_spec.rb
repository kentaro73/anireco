require 'rails_helper'

RSpec.describe "Posts", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:other_user)
    @admin_user = FactoryBot.create(:admin_user)
    @post = FactoryBot.create(:post)
  end


  describe "#create" do
    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        post_params = FactoryBot.attributes_for(:post)
        post posts_path, params: { post: post_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe "#update" do
    context "管理ユーザーとしてログインしているとき" do
      before do
        sign_in @admin_user
      end

      it "リクエストが成功すること" do
        patch post_url @post, params: { post: FactoryBot.attributes_for(:post) }
        expect(response).to have_http_status "302"
      end

      it "他のユーザーの投稿も更新できること" do
        expect do
          patch post_url @post, params: { post: FactoryBot.attributes_for(:other_post) }
        end.to change { Post.find(@post.id).title }.from("鬼滅の刃").to("氷菓")
      end

      it "一覧ページにリダイレクトすること" do
        patch post_url @post, params: { post: FactoryBot.attributes_for(:other_post) }
        expect(response).to redirect_to root_path
      end

      it "パラメータが不正な場合更新されないこと" do
        expect do
          patch post_url @post, params: { post: FactoryBot.attributes_for(:post, :invalid) }
        end.to_not change(Post.find(@post.id), :title)
      end

      it "パラメータが不正な場合エラーが表示されること" do
        patch post_url @post, params: { post: FactoryBot.attributes_for(:post, :invalid) }
        expect(response.body).to include "Title can't be blank"
      end

    end

    context "一般ユーザーとしてログインしているとき" do
      before do
        sign_in @user
      end

      it  "自分の投稿は更新できること" do
        @post = FactoryBot.create(:post, user_id: @user.id)
        expect do
          patch post_url @post, params: { post: FactoryBot.attributes_for(:other_post) }
        end.to change { Post.find(@post.id).title }.from("鬼滅の刃").to("氷菓")
      end
      
      it "他のユーザーの投稿は更新できないこと" do
        @post = FactoryBot.create(:post, user_id: @other_user.id)
        patch post_url @post, params: { post: FactoryBot.attributes_for(:post) }
        expect(response).to_not be_successful
      end

      it "他のユーザーの投稿を更新しようとするとルートパスにリダイレクトすること" do
        @post = FactoryBot.create(:post, user_id: @other_user.id)
        patch post_url @post, params: { post: FactoryBot.attributes_for(:post) }
        expect(response).to redirect_to root_path
      end

    end

    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        patch post_url @post, params: { post: FactoryBot.attributes_for(:post) }
        expect(response).to redirect_to new_user_session_path  
      end
    end
  end

  describe "#destroy" do
    context "管理ユーザーとしてログインしているとき" do
      before do 
        sign_in @admin_user
      end

      it "リクエストが成功すること" do
        delete post_url @post
        expect(response).to have_http_status "302"
      end

      it "どの投稿も削除できること" do
        expect do
          delete post_url @post
        end.to change(Post, :count).by(-1)
      end

      it "投稿一覧にリダイレクトすること" do
        delete post_url @post
        expect(response).to redirect_to root_path
      end

    end

    context "一般ユーザーとしてログインしているとき" do
      before do
        sign_in @user
      end

      it "自分の投稿は削除できること" do
        @post = FactoryBot.create(:post, user_id: @user.id)
        expect do
          delete post_url @post
        end.to change(Post, :count).by(-1)
      end

      it "他のユーザーの投稿は削除できないこと" do
        @post = FactoryBot.create(:post, user_id: @other_user.id)
        delete post_url @post
        expect(flash.notice).to include("You're not authorized.") 
      end
    end

    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        delete post_url @post
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


end
