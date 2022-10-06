class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

 # 自分がフォローされる
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  # 自分がフォローする
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
 
  # ユーザーをフォローする
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # ユーザーのフォローを外す
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    followings.include?(user)
  end

# 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match" #完全一致
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match" #前方一致
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match" #後方一致
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match" #部分一致
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
