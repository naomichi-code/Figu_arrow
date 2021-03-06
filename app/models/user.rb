class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :image_icon
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :arrows, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :rooms, through: :user_rooms
  has_many :chats, dependent: :destroy
  has_many :group_rooms, dependent: :destroy
  has_many :groups, through: :group_rooms
  has_many :group_chats, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #followerフォローする人を取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #followedフォローされる人を取得
  has_many :following_user, through: :follower, source: :followed #フォローしている人[follower]の中から自分にフォローされている人[followed]を探す（自分がフォローしている人）取得
  has_many :follower_user, through: :followed, source: :follower #フォローされている人[followed]の中から自分をフォローしている人を[follower]探す（自分をフォローしている人）取得

  validates :account_name, presence: true, length: {maximum: 10, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 500}
  validates :last_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name, presence: true
  validates :first_name_kana, presence: true
  validates :postal_code, presence: true,format: {with: /\A\d{3}[-]\d{4}\z/}
  validates :address, presence: true
  validates :phone_number, presence: true, format: {with: /\A\d{2,5}-\d{1,4}-\d{4}\z/}



  #フォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  #フォロー解除
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  #すでにフォロー済みであればtureを返す
  def following?(user)
    following_user.include?(user)
  end

  #ゲストユーザーを探す、作成する
  def self.guest
    user = User.find_or_create_by!(
      email: 'guest@example.com',
      account_name: 'ゲストユーザー',
      first_name: 'ゲスト',
      last_name: 'ユーザー',
      first_name_kana: 'げすと',
      last_name_kana: 'ゆーざー',
      postal_code: '123-1234',
      address: 'guestadress',
      phone_number: '123-1234-1234'
      ) do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end
end