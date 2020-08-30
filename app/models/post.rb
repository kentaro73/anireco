class Post < ApplicationRecord
  validates :title, presence: true
  has_one_attached :image
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  paginates_per 10
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy


  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

end
