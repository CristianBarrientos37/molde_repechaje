class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, except: [:index, :show]

  def index
    @schedules = Schedule.all.includes(:employee)
  end

  def show
    @schedule = Schedule.find(params[:id])
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user = current_user
    set_work_hours
    
    if @schedule.save
      redirect_to schedules_path, notice: 'Horario creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:name, :description, :employee_id, :shift_type)
  end

  def authorize_admin
    unless current_user&.user_type == 'administrator'
      redirect_to root_path, alert: 'Solo administradores pueden realizar esta acción'
    end
  end

  def set_work_hours
    hours = @schedule.shift_type == 'morning' ? 
      { start: '08:00', end: '17:00' } : 
      { start: '15:00', end: '24:00' }

    @schedule.work_hours = {
      'monday' => hours,
      'tuesday' => hours,
      'wednesday' => hours,
      'thursday' => hours,
      'friday' => hours
    }
  end
end
