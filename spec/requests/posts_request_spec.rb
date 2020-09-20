require 'rails_helper'

RSpec.describe "Posts", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:other_user)
    @admin_user = FactoryBot.create(:admin_user)
    @post = FactoryBot.create(:post)
  end

  describe "#index" do
    context "管理ユーザーとしてログインしているとき" do
      before do
        sign_in @admin_user
      end

      it "正常にレスポンスを返すこと" do
        get posts_path
        expect(response).to have_http_status "200"
      end

      it "「ユーザー一覧」と表示されていること" do
        get posts_path
        expect(body).to include("ユーザー一覧")
      end
      it "投稿が表示されていること" do
        get posts_path
        expect(body).to include("#{@post.title}")
      end

    end

    context "一般ユーザーとしてログインしているとき" do
      before do
        sign_in @user
      end

      it "正常にレスポンスを返すこと" do
        get posts_path
        expect(response).to have_http_status "200"
      end

      it "ユーザー名が表示されていること" do
        get posts_path 
        expect(body).to include("#{@user.name}")
      end

      it "投稿が表示されていること" do
        get posts_path
        expect(body).to include("#{@post.title}")
      end

    end

    context "ログインしていないとき" do
      it "正常にレスポンスを返すこと" do
        get posts_path
        expect(response).to have_http_status "200"
      end

      it "「会員登録」と表示されていること" do
        get posts_path
        expect(body).to include("会員登録")
      end

      it "投稿が表示されていること" do
        get posts_path
        expect(body).to include("#{@post.title}")
      end

    end

  end

  describe "#show" do
    context "管理ユーザーとしてログインしているとき" do
      before do
        sign_in @admin_user
        get post_path @post.id
      end

      it "正常なレスポンスを返すこと" do
        expect(response).to have_http_status "200"
      end

      it "「編集」が表示されていること" do
        expect(body).to include("編集")
      end

      it "「削除」が表示されていること" do
        expect(body).to include("削除")
      end

      it "タイトルが表示されていること" do
        expect(body).to include("#{@post.title}")
      end

      it "話数が表示されていること" do
        expect(body).to include("#{@post.episode}")
      end

      it "放送日が表示されていること" do
        expect(body).to include("#{@post.broadcast}")
      end

      it "制作が表示されていること" do
        expect(body).to include("#{@post.staff}")
      end

      it "声優が表示されていること" do
        expect(body).to include("#{@post.cast}")
      end

      it "好きなシーンが表示されていること" do
        expect(body).to include("#{@post.favorite_scene}")
      end

    end

    context "一般ユーザーとしてログインしているとき" do
      before do
        sign_in @user
      end

      it "正常なレスポンスを返すこと" do
        get post_path @post.id
        expect(response).to have_http_status "200"
      end

      it "自分の投稿の場合「編集」が表示されていること" do
        @post = FactoryBot.create(:post, user_id: @user.id)
        get post_path @post.id
        expect(body).to include("編集") 
      end

      it "自分の投稿の場合「削除」が表示されていること" do
        @post = FactoryBot.create(:post, user_id: @user.id)
        get post_path @post.id
        expect(body).to include("削除") 
      end

      it "自分の投稿でない場合「編集」が表示されていなこと" do
        get post_path @post.id
        expect(body).to_not include("編集")
      end

      it "自分の投稿でない場合「削除」が表示されていなこと" do
        get post_path @post.id
        expect(body).to_not include("削除")
      end

      it "タイトルが表示されていること" do
        get post_path @post.id
        expect(body).to include("#{@post.title}")
      end

      it "話数が表示されていること" do
        get post_path @post.id
        expect(body).to include("#{@post.episode}")
      end

      it "放送日が表示されていること" do
        get post_path @post.id
        expect(body).to include("#{@post.broadcast}")
      end

      it "制作が表示されていること" do
        get post_path @post.id
        expect(body).to include("#{@post.staff}")
      end

      it "声優が表示されていること" do
        get post_path @post.id
        expect(body).to include("#{@post.cast}")
      end

      it "好きなシーンが表示されていること" do
        get post_path @post.id
        expect(body).to include("#{@post.favorite_scene}")
      end

    end

    context "ログインしていないとき" do
      before do
        get post_path @post.id
      end
      it "正常なレスポンスを返すこと" do
        expect(response).to have_http_status "200"
      end
      
      it "「ログインするとコメントできる」が表示されていること" do
        expect(body).to include("ログインするとコメントできる")
      end
      
      it "タイトルが表示されていること" do
        expect(body).to include("#{@post.title}")
      end

      it "話数が表示されていること" do
        expect(body).to include("#{@post.episode}")
      end

      it "放送日が表示されていること" do
        expect(body).to include("#{@post.broadcast}")
      end

      it "制作が表示されていること" do
        expect(body).to include("#{@post.staff}")
      end

      it "声優が表示されていること" do
        expect(body).to include("#{@post.cast}")
      end

      it "好きなシーンが表示されていること" do
        expect(body).to include("#{@post.favorite_scene}")
      end
    end
  end

  describe "#new" do
    context "ログインしているとき" do
      before do
        sign_in @user
        get new_post_path
      end

      it "正常なレスポンスを返すこと" do
        expect(response).to be_successful
      end
    end

    context "ログインしていないとき" do
      before do
        get new_post_path
      end

      it "302レスポンスを返すこと" do
        expect(response).to have_http_status "302"
      end

      it "ログインページにリダイレクトされること" do
        expect(response).to redirect_to new_user_session_path
      end

      it "フラッシュメッセージが表示されること" do
        expect(flash.alert).to include("アカウント登録もしくはログインしてください")
      end

    end
  end

  describe "#create" do
    context "ログインしているとき" do

      it "投稿できること" do
        post_params = FactoryBot.attributes_for(:post)
        sign_in @user
        expect {
          post posts_path, params: { post: post_params }
        }.to change(@user.posts, :count).by(1)
      end
    end


    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        post_params = FactoryBot.attributes_for(:post)
        post posts_path, params: { post: post_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#edit" do
    context "管理ユーザーとしてログインしているとき" do
      before do
        sign_in @admin_user
      end

      it "どのユーザーの投稿編集ページにもアクセスできること" do
        @post = FactoryBot.create(:post, user_id: @user.id)
        get edit_post_path @post.id
        expect(response).to be_successful
      end

    end

    context "一般ユーザーとしてログインしているとき" do
      before do
        sign_in @user
      end
      
      it "自分の編集ページはアクセスできること" do
        @post = FactoryBot.create(:post, user_id: @user.id)
        get edit_post_path @post.id
        expect(response).to be_successful
      end

      it "自分以外編集ページの場合ルートパスにリダイレクトすること" do
        @post = FactoryBot.create(:post, user_id: @other_user.id)
        get edit_post_path @post.id
        expect(response).to redirect_to root_path
      end
    end

    context "ログインしていないとき" do
      it "ログイン画面にリダイレクトすること" do
        get edit_post_path @post.id
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
        end.to change { Post.find(@post.id).title }.from("test title").to("other title")
      end

      it "一覧ページにリダイレクトすること" do
        patch post_url @post, params: { post: FactoryBot.attributes_for(:other_post) }
        expect(response).to redirect_to posts_path
      end

      it "パラメータが不正な場合更新されないこと" do
        expect do
          patch post_url @post, params: { post: FactoryBot.attributes_for(:post, :invalid) }
        end.to_not change(Post.find(@post.id), :title)
      end

      it "パラメータが不正な場合エラーが表示されること" do
        patch post_url @post, params: { post: FactoryBot.attributes_for(:post, :invalid) }
        expect(body).to include("タイトルを入力してください")
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
        end.to change { Post.find(@post.id).title }.from("test title").to("other title")
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
        expect(response).to redirect_to posts_path
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
        expect(flash.notice).to include("権限がありません") 
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
