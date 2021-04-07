require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe "共通ヘッダーに" do
    context "ログインしていないとき" do
      before do
        visit root_path                               # root_pathは投稿一覧ページ
      end

      it "会員登録リンクがあり、機能していること" do
        click_link "Signup"
        expect(current_path).to eq new_user_registration_path
      end

      it "ログインリンクがあり、機能していること" do
        click_link "Login", match: :first
        expect(current_path).to eq new_user_session_path
      end

      it "お気に入り、ユーザー一覧と表示されていないこと" do
        expect(page).to have_no_link "Favorite"
        expect(page).to have_no_link "Users"
      end

      it "ゲストログインできること" do
        click_link "Skip Signup"
        expect(page).to have_content "Logged in as a guest user."
      end
    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:other_user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        @other_post = FactoryBot.create(:other_post, user_id: @other_user.id)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"  
      end

      it "ログインしているユーザのリンクが機能していること" do
        within ".navbar-brand" do
          click_link "#{@user.name}"
        end
        expect(current_path).to eq user_path(@user)
      end

      it "お気に入りリンクが機能していること" do
        click_link "Favorite"
        expect(current_path).to eq "/like_lists"
      end

      it "投稿ページへのリンクが機能していること" do
        click_link "Posting"
        expect(current_path).to eq new_post_path
      end

      it "ログアウトリンクが機能していること" do
        click_link "Logout"
        expect(page).to have_content "Signed out successfully."
      end
    end

    context "管理ユーザとしてログインしているとき" do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        @user = FactoryBot.create(:user)
        visit new_user_session_path
        fill_in "Email", with: @admin_user.email
        fill_in "Password", with: @admin_user.password
        click_button "Log in"
        visit root_path
      end

      it "ユーザー一覧リンクが表示され、機能していること" do
        click_link "Users" 
        expect(current_path).to eq users_path
      end
    end
  end

  describe "投稿一覧ページで" do
    before do 
      @post = FactoryBot.create(:post)
    end

    context "ログインしていないとき" do
      before do
        visit posts_path
      end

      it "ウェルカムページに遷移すること" do
        expect(current_path).to eq "/welcomes"
      end

    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:other_user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        @other_post = FactoryBot.create(:other_post, user_id: @other_user.id)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"
      end
  
      it "投稿したユーザーのリンクが機能していること" do
        click_link "#{@other_user.name}"
        expect(current_path).to eq user_path(@other_user)
      end

      it "投稿が表示されていること" do
        expect(find(".caption", visible: false, match: :first).hover).to have_content "#{@other_post.title}"
      end
    end
    # 管理ユーザは一般ユーザと処理を変えていないので省略
  end

  describe "投稿詳細ページで" do
    context "ログインしていないとき" do
      before do
        @post = FactoryBot.create(:post)
        visit post_path(@post)
      end

      it "ログイン導線があること" do
        expect(page).to have_content "You will be able to comment when you log in!"
        expect(page).to have_link "Login"
      end
      it "登録された内容が表示されていること" do
        expect(body).to include("#{@post.title}")           # アニメタイトル
        expect(body).to include("#{@post.episode}")         # 話数
        expect(body).to include("#{@post.broadcast}")       # 放送日
        expect(body).to include("#{@post.staff}")           # アニメーション制作
        expect(body).to include("#{@post.cast}")            # 声優
        expect(body).to include("#{@post.favorite_scene}")  # 好きなシーン
      end
    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @other_user =  FactoryBot.create(:user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        @other_post = FactoryBot.create(:other_post)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"
      end

      it "他のユーザーの投稿には編集、削除リンクがないこと" do
        visit post_path(@other_post)
        expect(page).to have_no_link "Edit"
        expect(page).to have_no_link "Delete"
      end

      it "自分の投稿には編集リンクがあり、機能していること" do
        visit post_path(@post)
        click_link "Edit"
        expect(current_path).to eq edit_post_path(@post)
      end

      it "自分の投稿には削除リンクがあり、機能していること" do
        visit post_path(@post)
        click_link "Delete"
        expect{
          expect(page.accept_confirm).to eq "#{@post.title} will be deleted. Are you sure?"
          expect(page).to have_content "#{@post.title} deleted successfully."
          }.to change(@user.posts, :count).by(-1)
      end
    end
    

    context "管理ユーザとしてログインしているとき" do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        @user = FactoryBot.create(:user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        visit new_user_session_path
        fill_in "Email", with: @admin_user.email
        fill_in "Password", with: @admin_user.password
        click_button "Log in"
      end

      it "他のユーザの投稿にも編集リンクがあり、機能していること" do
        visit post_path(@post)
        click_link "Edit"
        expect(current_path).to eq edit_post_path(@post)
      end

      it "他のユーザの投稿にも削除リンクがあり、機能していること" do
        visit post_path(@post)
        click_link "Delete"
        expect{
          expect(page.accept_confirm).to eq "#{@post.title} will be deleted. Are you sure?"
          expect(page).to have_content "#{@post.title} deleted successfully."
          }.to change(@user.posts, :count).by(-1)
      end
    end
  end

  describe "新規投稿ページで" do
    context "ログインしていないとき" do
      it "ログインを促されること" do
        visit new_post_path
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end
    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:other_user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        @other_post = FactoryBot.create(:other_post, user_id: @other_user.id)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"
      end
  
      it "投稿を作成できること" do
        visit new_post_path
        expect {
          fill_in "Title", with: "コードギアス"
          fill_in "Tag name", with: "バトル"
          attach_file "Image", "#{Rails.root}/spec/factories/コードギアス.jpeg"
          fill_in "Episode", with: 50
          fill_in "Broadcast", with: "2006年秋"
          fill_in "Cast", with: "福山潤/ゆかな"
          fill_in "Staff", with: "サンライズ"
          fill_in "Favorite scene", with: "撃っていいのは撃たれる覚悟のある奴だけだ"
          click_button "Post" 
          expect(page).to have_content "バトル"   # タグが表示されているか
          expect(page).to have_content "コードギアス posted successfully."
        }.to change(@user.posts, :count).by(1)
      end

      it "タイトルが未入力だと失敗すること" do
        visit new_post_path
        fill_in "Title", with: nil
        click_button "Post"
        expect(page).to have_content "Title can't be blank"
      end

      it "タイトル以外が未入力でも登録できること" do
        visit new_post_path
        fill_in "Title", with: "名探偵コナン"
        click_button "Post"
        expect(page).to have_content "名探偵コナン posted successfully."
        expect(current_path).to eq root_path
      end
    end
    # 管理ユーザも登録できるが不適切な投稿削除が目的のため省略
  end

  describe "投稿編集ページで" do
    context "ログインしていないとき" do
      before do
        @post = FactoryBot.create(:post)
        visit edit_post_path(@post)
      end

      it "ログインが促されること" do
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end
    end

    context "ログインしているとき" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:other_user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        @other_post = FactoryBot.create(:other_post, user_id: @other_user.id)
        visit new_user_session_path
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Log in"  
      end

      it "更新できること" do
        visit edit_post_path(@post)
        expect {
          fill_in "Title", with: "コードギアス 反逆のルルーシュ"
          fill_in "Cast", with: "福山潤/ゆかな/小清水亜美/櫻井孝宏"
          click_button "Post" 
        }.to change(Post, :count).by(0)
        expect(@post.reload.title).to eq "コードギアス 反逆のルルーシュ"
        expect(@post.reload.cast).to eq "福山潤/ゆかな/小清水亜美/櫻井孝宏"
        expect(page).to have_content "#{@post.title} updated successfully."
      end

      it "タイトルがないと更新できないこと" do
        visit edit_post_path(@post)
        fill_in "Title", with: nil
        click_button "Post"
        expect(page).to have_content "Title can't be blank"
      end

      it "他のユーザーの編集ページにはいけないこと" do
        visit edit_post_path(@other_post)
        expect(page).to have_content "You're not authorized."
      end
    end

    context "管理ユーザとしてログインしているとき" do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        @user = FactoryBot.create(:user)
        @post = FactoryBot.create(:post, user_id: @user.id)
        visit new_user_session_path
        fill_in "Email", with: @admin_user.email
        fill_in "Password", with: @admin_user.password
        click_button "Log in"  
      end

      it "他のユーザーの投稿も更新できること" do
        visit edit_post_path(@post)
        expect {
          fill_in "Title", with: "コードギアス 反逆のルルーシュ"
          fill_in "Cast", with: "福山潤/ゆかな/小清水亜美/櫻井孝宏"
          click_button "Post" 
        }.to change(Post, :count).by(0)
        expect(@post.reload.title).to eq "コードギアス 反逆のルルーシュ"
        expect(@post.reload.cast).to eq "福山潤/ゆかな/小清水亜美/櫻井孝宏"
        expect(page).to have_content "#{@post.title} updated successfully."
      end
    end
  end
end