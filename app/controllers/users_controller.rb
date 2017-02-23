class UsersController < ApplicationController
  def show
    @user = User.includes(logs: [entries: [:recipe]]).find(params[:id])
  end
end
