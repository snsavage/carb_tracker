class LogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @log = Log.new
    @log.entries.build
  end

  def create
    @log = current_user.logs.create(log_params)

    redirect_to user_path(current_user)
  end

  private
  def log_params
    params.require(:log).permit(entries_attributes: [:quantity, :recipe_id, :category])
  end
end
