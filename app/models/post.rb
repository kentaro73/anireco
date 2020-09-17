class Post < ApplicationRecord
  validates :title, presence: true
  has_one_attached :image
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  paginates_per 9
  # コメント機能リレーション
  has_many :comments, dependent: :destroy
  # お気に入り機能リレーション
  has_many :likes, dependent: :destroy
  # タグ機能リレーション
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # 投稿に画像が添付されていない時の画像
  before_create :default_image
  def default_image
    unless self.image.attached?
      self.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "no_image.jpg")), filename: "no_image.jpg", content_type: "image/jpg")
    end
  end



  # 検索機能
  scope :search, -> (search_params) do
    return if search_params.blank?
    
    title_like(search_params[:title])
      .cast_like(search_params[:cast])
      .episode_is(search_params[:episode])
  end
  scope :title_like, -> (title) { where('title LIKE ?', "%#{title}%") if title.present?}
  # castはpostgresqlの予約語のためダブルクオテーションで囲む必要がある
  scope :cast_like, -> (cast) { where('"cast" LIKE ?', "%#{cast}%") if cast.present?}
  scope :episode_is, -> (episode) { where(episode: episode) if episode.present?}


  def save_posts(tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old|
      self.post_tags.delete Tag.find_by(tag_name: old)
    end
    
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_post_tag
    end
  end


end
