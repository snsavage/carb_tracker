class LogsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, except: [:index, :new, :create]
  after_action :verify_policy_scoped, only: :index

  def index
    @logs = policy_scope(Log).order(log_date: :desc)
    @log_data = policy_scope(Log).daily_carb_data(current_user)
  end

  def show
    @log = Log.find(params[:id])
    @recipes = policy_scope(Recipe)
    authorize @log

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @log, user: current_user }
    end
  end

  def today
    @log = current_user
           .logs.find_or_initialize_by(log_date: Time.current.to_date)
    @recipes = policy_scope(Recipe)
    authorize @log

    render :new
  end

  def new
    @log = current_user.logs.new
    @recipes = policy_scope(Recipe)
  end

  def create
    @log = current_user.logs.find_or_create_by(id: params[:id])
    @log.update(log_params)
    @log.save

    if @log.valid?
      redirect_to user_log_path(current_user, @log)
    else
      render :new
    end
  end

  def edit
    @log = current_user.logs.find(params[:id])
    @recipes = policy_scope(Recipe)
    authorize @log
  end

  def update
    @log = current_user.logs.includes(:entries).find(params[:id])
    authorize @log

    @log.update(log_params)
    if @log.save
      respond_to do |format|
        format.html { redirect_to user_log_path(current_user, @log) }
        format.json { render json: @log, user: current_user }
      end
    else
      @recipes = policy_scope(Recipe)
      render :edit
    end
  end

  def destroy
    @log = Log.find(params[:id])
    authorize @log

    if @log.destroy
      redirect_to user_logs_path, notice: 'Your log was deleted.'
    else
      redirect_to user_log_paht(@log),
                  alert: 'Your log could not be deleted.'
    end
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
