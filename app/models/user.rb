class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_validation :set_favorite_anime
  before_validation :set_nameless_name
  has_one_attached :avatar, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  def set_nameless_name
    self.name = "ゲスト" if name.blank?
  end

  def set_favorite_anime
    self.favorite_anime = "未登録" if favorite_anime.blank?
  end

  before_create :default_avatar
  def default_avatar
    unless self.avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "default_icon.png")), filename: "default_icon.png", content_type: "image/png")
    end
  end

end
