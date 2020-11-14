require 'rails_helper'

RSpec.describe "Tags", type: :system do
  describe "投稿一覧ページで" do
    context "ログインしているとき" do
      before do
        @tag = FactoryBot.create(:tag)
        visit root_path
        click_link "Skip Signup"
      end
      it "タグが表示されていること" do
        visit posts_path
        expect(page).to have_content "#{@tag.tag_name}"
      end
    end
  end
end