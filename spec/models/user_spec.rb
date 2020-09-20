require 'rails_helper'

RSpec.describe User, type: :model do
  
  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  # メール、パスワードがあれば有効な状態であること
  it "is valid with email and password" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end
  # メールアドレスがなければ無効なこと
  it "is invalid without email" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors.of_kind?(:email, :blank)).to be_truthy
    # ↑expect(user.errors.added?(:email, :blank)).to be_truthy と同じ
    # added?だと動的な値が埋め込まれる場合指定する必要があるがof_kind?だと必要ない(rails6の場合)
  end
  # 重複したメールアドレスなら無効なこと
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "hoge@example.com")
    user = FactoryBot.build(:user, email: "hoge@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end
  # 複数のユーザーで何かする
  it "does something with multiple users" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(true).to be_truthy
  end
  # nameを入力しない場合は「ゲスト」になること
  it "is guest if name is blank" do
    user = FactoryBot.create(:user, name: nil)
    user.valid?
    expect(user[:name]).to include("ゲスト")
  end
  # favorite_animeを入力しない場合は「未登録」になること
  it "is 「未登録」 if favorite_anime is blank" do
    user = FactoryBot.create(:user, favorite_anime: nil)
    user.valid?
    expect(user[:favorite_anime]).to include("未登録")
  end
end
