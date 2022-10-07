class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  # 検索方法分岐
  def self.search_for(content, method)
    if method == 'perfect' #完全一致
      Book.where(title: content)
    elsif method == 'forward' #前方一致
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward' 
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
  
end
