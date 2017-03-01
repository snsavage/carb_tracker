class LogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @logs = current_user.logs.includes(entries: [:recipe])
  end

  def show
    # @log = Log.includes(entries: [:recipe]).find(params[:id])
    # @log = Log.includes(:recipes).find(params[:id])
    @log = Log.find(params[:id])
  end

  def today
    @log = Log.find_or_initialize_by(log_date: Time.current.to_date)
    render :new
  end

  def new
    @log = Log.new
  end

  def create
    @log = current_user.logs.find_or_create_by(id: params[:id])
    @log.update(log_params)
    @log.save

    if @log.valid?
      redirect_to logs_path
    else
      render :new
    end
  end

  def edit
    @log = current_user.logs.find(params[:id])
  end

  def update
    @log = current_user.logs.includes(:entries).find(params[:id])
    @log.update(log_params)
    @log.save

    redirect_to logs_path
  end

  private
  def log_params
    params.require(:log).permit(
      :log_date, entries_attributes: [
        :id, :quantity, :recipe_id, :category, :_destroy
      ]
    )
  end
end
