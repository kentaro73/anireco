require 'rails_helper'

RSpec.describe "Users", type: :request do

  # ユーザー一覧ページ（管理者のみ）
  describe "#index" do
    context "ログインしていないとき" do
      before do
        get users_path
      end

      it "302レスポンスを返すこと" do
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトすること" do
        expect(response).to redirect_to new_user_session_path
      end

      it "フラッシュメッセージが表示されること" do
        expect(flash.alert).to include("アカウント登録もしくはログインしてください")
      end
    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        sign_in @user
        get users_path
      end

      it "302レスポンスを返すこと" do
        expect(response).to have_http_status "302"
      end

      it "ルートパスにリダイレクトすること" do
        expect(response).to redirect_to root_path
      end

      it "フラッシュメッセージが表示されること" do
        expect(flash.notice).to include("権限がありません")
      end
    end

    context "管理ユーザーとしてログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @admin_user = FactoryBot.create(:admin_user)
        sign_in @admin_user
        get users_path
      end

      it "正常なレスポンスを返すこと" do
        expect(response).to have_http_status "200"
      end

      it "「ユーザー一覧」が表示されていること" do
        expect(body).to include("ユーザー一覧")
      end

      it "ユーザー名が表示されていること" do
        expect(body).to include("佐藤健")
      end

      it "「削除」が表示されていること" do
        expect(body).to include("削除")
      end
    end
  end

  # ユーザー詳細ページ
  describe "#show" do
    context "ユーザーが存在する場合" do
      let(:user) { FactoryBot.create(:user) }
      it "リクエストが成功すること" do
        get user_path user.id
        expect(response).to have_http_status "200"
      end
      it "ユーザー名が表示されていること" do
        get user_path user.id
        expect(body).to include("佐藤健")
      end
    end
    context "ユーザーが存在しない場合" do
      subject { -> { get user_path 1 } }

      it { is_expected.to raise_error ActiveRecord::RecordNotFound }
    end
  end
  # ユーザー削除（管理者のみ）
  describe "#destroy" do
    before do
      @admin_user = FactoryBot.create(:admin_user)
      @user = FactoryBot.create(:user)
    end  
    context "ログインしていないとき" do
      it "ルートパスにリダイレクトすること" do
        delete user_path(@user)
        expect(response).to redirect_to root_path
      end
      it "フラッシュメッセージが表示されること" do 
        delete user_path(@user)
        expect(flash.notice).to include("権限がありません")
      end
    end
    context "ログインしているとき" do
      it "管理者の場合リクエストが成功すること" do
        sign_in @admin_user
        delete user_path(@user)
        expect(response).to have_http_status "302"
      end
      it "管理者の場合ユーザーが削除できること" do
        sign_in @admin_user
        expect do
          delete user_path(@user)
        end.to change(User, :count).by(-1)
      end
      it "管理者として削除した後、ユーザー一覧にリダイレクトされること" do
        sign_in @admin_user
        delete user_path(@user)
        expect(response).to redirect_to users_path
      end
      it "一般ユーザーの場合ルートパスにリダイレクトすること" do
        sign_in @user
        delete user_path(@user)
        expect(response).to redirect_to root_path
      end
    end
  end


end
