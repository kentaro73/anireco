class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_validation :set_favorite_anime
  has_one_attached :avatar
  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

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
