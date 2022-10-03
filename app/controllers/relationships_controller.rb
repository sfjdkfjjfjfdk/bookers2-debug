class RelationshipsController < ApplicationController

# フォローするとき
  def create
   current_user.follow(params[:user_id])
   redirect_to user_path(@user)
  end
# フォロー外すとき
  def destroy
   current_user.unfollow(params[:user_id])
   redirect_to user_path(@user)
  end
# フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.following_user.page(params[:page])
  end
 # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.follower_user.page(params[:page])
  end
end
