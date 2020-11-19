require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザー一覧ページで" do
    context "ログインしていないとき" do
      before do 
        visit users_path
      end

      it "アクセスできないこと" do
        visit users_path
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end
    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"
        visit users_path
      end

      it "アクセスできないこと" do
        expect(page).to have_content "You're not authorized."
        expect(current_path).to eq root_path
      end
    end

    context "管理ユーザーとしてログインしているとき" do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:other_user)
        visit new_user_session_path
        fill_in "Email", with: @admin_user.email
        fill_in "Password", with: @admin_user.password
        click_button "Log in"
        visit users_path
      end

      it "ユーザ一覧が表示されること" do
        expect(page).to have_content "#{@user.name}"
        expect(page).to have_content "#{@other_user.name}"
      end

      it "削除リンクが表示されること" do
        expect(page).to have_link "削除", match: :first
      end
    end

  end

  describe "ユーザー詳細ページ" do
    context "ログインしていないとき" do
      before do
        @user = FactoryBot.create(:user, favorite_anime: "名探偵コナン")
        @post = FactoryBot.create(:post, user_id: @user.id, episode: "200")
      end
      
      it "総視聴話数が表示されていること" do
        visit user_path(@user)
        expect(page).to have_content "200 episodes"
      end

      it "好きなアニメが表示されていること" do
        visit user_path(@user)
        expect(page).to have_content "名探偵コナン"
      end

    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:other_user)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"
      end

      it "自分のページには編集リンクがあり、機能していること" do
        visit user_path(@user)
        click_link "Edit"
        expect(current_path).to eq edit_user_registration_path
      end

      it "他のユーザーのページには編集リンクがないこと" do
        visit user_path(@other_user)
        expect(page).to have_no_link "Edit"
      end
    end

  end
  
  describe "アカウント登録ページ" do
    before do 
      visit new_user_registration_path
    end

    it "アカウント登録できること" do
      fill_in "Name", with: "佐藤健"
      fill_in "Favorite anime", with: "るろうに剣心"
      fill_in "Email", with: "satoutakeru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      expect(current_path).to eq root_path
      expect(page).to have_content "Welcome! You have signed up successfully."
      expect(page).to have_link "佐藤健"
    end

    it "31文字以上の名前は登録できないこと" do
      fill_in "Name", with: "a"*31
      fill_in "Email", with: "satoutakeru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      expect(page).to have_selector 'li', text: "Name is too long"
    end

    it "メールアドレスがないと登録できないこと" do
      fill_in "Name", with: "佐藤健"
      fill_in "Favorite anime", with: "るろうに剣心"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      expect(page).to have_selector 'li', text: "Email can't be blank"
    end

    it "パスワードがないと登録できないこと" do
      fill_in "Name", with: "佐藤健"
      fill_in "Favorite anime", with: "るろうに剣心"
      fill_in "Email", with: "satoutakeru@example.com"
      click_button "Sign up"
      expect(page).to have_selector "li", text: "Password can't be blank"
    end

    it "名前が未入力だとゲストという名前になること" do
      fill_in "Favorite anime", with: "るろうに剣心"
      fill_in "Email", with: "satoutakeru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      expect(page).to have_link "Guest"
    end

    it "アイコンが未入力でも登録できること" do
      fill_in "Name", with: "佐藤健"
      fill_in "Favorite anime", with: "るろうに剣心"
      fill_in "Email", with: "satoutakeru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      expect(current_path).to eq root_path
      expect(page).to have_content "Welcome! You have signed up successfully."
    end

    it "好きなアニメが未入力でも登録できること" do
      fill_in "Name", with: "佐藤健"
      fill_in "Email", with: "satoutakeru@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      expect(current_path).to eq root_path
      expect(page).to have_content "Welcome! You have signed up successfully."
    end

    it "好きなアニメが101文字以上だと詳細ページでUnregisteredとなること" do
      fill_in "Email", with: "satoutakeru@example.com"
      fill_in "Favorite anime", with: "a"*101
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"
      click_link "Guest"
      expect(page).to have_content "Unregistered"
    end
  end

  describe "ログイン後" do
    before do
      @user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Log in"
      visit user_path(@user)
    end
  end

  describe "管理ユーザとして" do
    before do
      @admin_user = FactoryBot.create(:admin_user)
      @user = FactoryBot.create(:user)
      visit new_user_session_path
      fill_in "Email", with: @admin_user.email
      fill_in "Password", with: @admin_user.password
      click_button "Log in"
    end

    context "共通ヘッダーに" do
      before do
        visit root_path
      end

      it "ユーザー一覧リンクが表示されていること" do
        expect(page).to have_link "Users"
      end
    end
  end

end