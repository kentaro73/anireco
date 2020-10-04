require 'rails_helper'

RSpec.describe "Search", type: :system do
  describe "投稿一覧ページにある検索フォームで" do            
    context "ログインしていないとき" do
      before do
        @post = FactoryBot.create(:post)
        @other_post = FactoryBot.create(:other_post)
        visit root_path
      end

      it "タイトルで検索できること" do
        fill_in "title", with: "#{@post.title}"
        within ".search-form" do
          find("#search_title_button").click_button
        end
        expect(find(".caption", visible: false, match: :first).hover).to have_content "#{@post.title}"
      end

      it "声優で検索できること" do
        fill_in "cast", with: "#{@post.cast}"
        within ".search-form" do
          find("#search_cast_button").click_button
        end
        expect(find(".caption", visible: false, match: :first).hover).to have_content "#{@post.title}"
      end

      it "話数で検索できること" do
        fill_in "episode", with: "#{@post.episode}"
        within ".search-form" do
          find("#search_episode_button").click_button
        end
        expect(find(".caption", visible: false, match: :first).hover).to have_content "#{@post.title}"
      end
    end
    # ログインしているときとログインしていないときとで処理を変えていないので省略
  end
end