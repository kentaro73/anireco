require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    @post = FactoryBot.create(:post)
    @other_post = FactoryBot.create(:other_post)
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:other_user)
    @comment = FactoryBot.create(:comment, post_id: @post.id, user_id: @user.id )
    @other_comment = FactoryBot.create(:comment, post_id: @other_post.id, user_id: @other_user.id)
  end

  describe "投稿詳細ページで" do
    context "ログインしていないとき" do
      before do
        visit post_path(@post)
      end

      it "コメントボタンがないこと" do
        expect(page).to have_no_button "コメントする"
      end

      it "コメントが表示されていること" do
        expect(page).to have_content "#{@comment.content}"
      end

      it "コメントしたユーザーのリンクがあること" do
        expect(page).to have_link "#{@comment.user.name}"
      end

      it "削除リンクが出ていないこと" do
        expect(page).to have_no_link "削除"
      end
    end

    context "ログインしているとき" do
      before do
        visit new_user_session_path
        fill_in "Eメール", with: "#{@user.email}"
        fill_in "パスワード", with: "#{@user.password}"
        click_button "ログイン"
        visit post_path(@post)
      end

      it "コメントできること" do
        fill_in "コメント", with: "私もこの作品が好きです"
        click_button "コメントする" 
        expect(page).to have_content "私もこの作品が好きです"
      end

      it "削除できること" do
        click_link "削除"
        expect{
          expect(page.accept_confirm).to eq "#{@comment.content}を削除します。よろしいですか？"
          expect(page).to have_content "#{@comment.content}を削除しました"
          }.to change(@user.comments, :count).by(-1)
      end

      it "他のユーザーの投稿には削除リンクが出ていないこと" do
        visit post_path(@other_post)
        expect(page).to have_no_link "削除"
      end
    end

    context "管理ユーザとしてログインしているとき" do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        visit new_user_session_path
        fill_in "Eメール", with: "#{@admin_user.email}"
        fill_in "パスワード", with: "#{@admin_user.password}"
        click_button "ログイン"
      end

      it "他のユーザーのコメントも削除できること" do
        visit post_path(@other_post)
        within ".comment-delete" do
          click_link "削除"
        end
        expect{
          expect(page.accept_confirm).to eq "#{@other_comment.content}を削除します。よろしいですか？"
          expect(page).to have_content "#{@other_comment.content}を削除しました"
          }.to change(@other_user.comments, :count).by(-1)
      end
    end
  end
end