class LogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def new
    @log = Log.new
    @log.entries.build
  end

  def create
    @log = current_user.logs.create(log_params)

    if @log.valid?
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def edit
    @log = current_user.logs.find(params[:id])
  end

  def update
    @log = current_user.logs.find(params[:id])
    @log.update(log_params)
    @log.save

    redirect_to user_path(current_user)
  end

  private
  def log_params
    params.require(:log).permit(
      entries_attributes: [:id, :quantity, :recipe_id, :category, :_destroy]
    )
  end
end
