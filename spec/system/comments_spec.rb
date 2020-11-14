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
        expect(page).to have_no_button "Comment"
      end

      it "コメントが表示されていること" do
        expect(page).to have_content "#{@comment.content}"
      end

      it "コメントしたユーザーのリンクがあること" do
        expect(page).to have_link "#{@comment.user.name}"
      end

      it "削除リンクが出ていないこと" do
        expect(page).to have_no_link "Delete"
      end
    end

    context "ログインしているとき" do
      before do
        visit new_user_session_path
        fill_in "Email", with: "#{@user.email}"
        fill_in "Password", with: "#{@user.password}"
        click_button "Log in"
        visit post_path(@post)
      end

      it "コメントできること" do
        fill_in "Content", with: "私もこの作品が好きです"
        click_button "Comment" 
        expect(page).to have_content "私もこの作品が好きです"
      end

      it "削除できること" do
        click_link "Delete"
        expect{
          expect(page.accept_confirm).to eq "#{@comment.content} will be deleted. Are you sure?"
          expect(page).to have_content "#{@comment.content} deleted successfully."
          }.to change(@user.comments, :count).by(-1)
      end

      it "他のユーザーの投稿には削除リンクが出ていないこと" do
        visit post_path(@other_post)
        expect(page).to have_no_link "Delete"
      end
    end

    context "管理ユーザとしてログインしているとき" do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        visit new_user_session_path
        fill_in "Email", with: "#{@admin_user.email}"
        fill_in "Password", with: "#{@admin_user.password}"
        click_button "Log in"
      end

      it "他のユーザーのコメントも削除できること" do
        visit post_path(@other_post)
        within ".comment-delete" do
          click_link "Delete"
        end
        expect{
          expect(page.accept_confirm).to eq "#{@other_comment.content} will be deleted. Are you sure?"
          expect(page).to have_content "#{@other_comment.content} deleted successfully."
          }.to change(@other_user.comments, :count).by(-1)
      end
    end
  end
end