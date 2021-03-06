class Users::RelationshipsController < ApplicationController
  before_action :authenticate_user!,unless: :admin_signed_in?
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followed
    @user = User.find(params[:user_id])
    @users = @user.following_user.page(params[:page]).per(10).order(created_at: :desc)
  end

  def follower
    @user = User.find(params[:user_id])
    @users = @user.follower_user.page(params[:page]).per(10).order(created_at: :desc)
  end
end
