class Post < ApplicationRecord
  validates :title, presence: true
  has_one_attached :image
  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  paginates_per 10
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # 検索機能
  scope :search, -> (search_params) do
    return if search_params.blank?
    
    title_like(search_params[:title])
      .cast_is(search_params[:cast])
      .episode_is(search_params[:episode])
  end
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present?}
  scope :cast_is, -> (cast) { where(cast: cast) if cast.present?}
  scope :episode_is, -> (episode) { where(episode: episode) if episode.present?}


  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end


end
