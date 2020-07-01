class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->   { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

    # 怪文書キーワード
    PERIODS   = %w(今日、 昨日、 昔、 今朝、 今夜、 昼下がり、 深夜、 )
    LOCATIONS = %w(家の中 家の庭 ジャングル 北極 南極 砂漠 山 雪山 草原 海 川 田んぼ 南国 北国 無人島 森 洞窟  コンビニ)
    SIZES     = %w(大きな 巨大な 小さな 手のひらサイズの 普通サイズの)
    COLORS    = %w(普通色 黒色 白色 金色 銀色 透明 七色)
    ANIMALS   = %w(犬 猫 ウサギ パンダ ペンギン ハムスター イルカ キリン ゾウ ライオン ヒツジ クマ アザラシ カンガルー)
    ACTIONS   = %w(と遊んだ と食事をした と目が合った に助けられた を救った)

  # 怪文書を渡す
  def self.generate_mysterious_document
    mysterious_document = <<~TEXT
			【怪文書】#{PERIODS.sample}#{LOCATIONS.sample}で#{SIZES.sample}#{COLORS.sample}の#{ANIMALS.sample}#{ACTIONS.sample}。
    TEXT
  end

  # 投稿文のキーワードを検索するクエリ生成
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      all
    end
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
