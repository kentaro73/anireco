require 'rails_helper'

RSpec.describe "Likes", type: :system do
  describe "投稿詳細ページで" do
    context "ログインしていないとき" do
      before do
        @post = FactoryBot.create(:post)
        visit post_path(@post)
      end

      it "ログインページに遷移すること" do
        find(".fa-yellow").click
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ログインしているとき" do
      before do
        @post = FactoryBot.create(:post)
        @user = FactoryBot.create(:user)
        visit new_user_session_path
        fill_in "Eメール", with: @user.email
        fill_in "パスワード", with: @user.password
        click_button "ログイン"
        visit post_path(@post)
      end

      it "お気に入り登録できること" do
        expect {
          find(".fa-yellow").click
        }.to change(@post.likes, :count).by(1)
      end

      it "お気に入り削除できること" do
        find(".fa-yellow").click
        expect {
          find(".fa-yellow").click
        }.to change(@post.likes, :count).by(-1)
      end
    end
  end
end