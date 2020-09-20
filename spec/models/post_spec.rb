require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @user = User.create(
      name: "hoge",
      email: "hoge@example.com",
      password: "hogehoge",
    )
  end
  # ユーザー、タイトルがあれば有効な状態であること
  it "is valid with an user and title" do
    post = Post.new(
      title: "アニメタイトル",
      user: @user,
    )
  end
  # タイトルがないと無効なこと
  it "is invalid without title" do
    post = Post.new(title: nil)
    post.valid?
    expect(post.errors.of_kind?(:title, :blank)).to be_truthy
    # expect(post.errors[:title]).to include("を入力してください")と同じ
  end

  # パラメータに一致するメッセージを検索する
  describe "search title, cast, and episode for a term" do
    before do
      @post1 = @user.posts.create(
        title: "進撃の巨人",
        cast: "梶裕貴",
        episode: "20",
        user: @user,
      )
      @post2 = @user.posts.create(
        title: "鬼滅の刃",
        cast: "花江夏樹",
        episode: "26",
        user: @user,
      )
      @post3 = @user.posts.create(
        title: "進撃の巨人中学校",
        cast: "梶裕貴/石川由依",
        episode: "20",
        user: @user,
      )
    end
    # 一致するデータが見つかるとき
    context do
      # 検索文字列に一致する投稿を返すこと
      it "returns posts that match the search term" do
        expect(Post.search(title: "進撃の巨人")).to include(@post1, @post3)
        expect(Post.search(title: "進撃の巨人")).to_not include(@post2)
        expect(Post.search(cast: "梶裕貴")).to include(@post1, @post3)
        expect(Post.search(cast: "梶裕貴")).to_not include(@post2)
        expect(Post.search(episode: 20)).to include(@post1, @post3)
        expect(Post.search(episode: 20)).to_not include(@post2)
      end
    end
    # 一致するデータが１件も見つからないとき
    context "when no match is found" do
      # 検索結果が１件も見つからなければ空のコレクションを返すこと
      it "returns an empty collection when no results are found" do
        expect(Post.search(title: "コードギアス")).to be_empty
        expect(Post.search(cast: "福山潤")).to be_empty
        expect(Post.search(episode: 50)).to be_empty
      end
    end
  end
end
