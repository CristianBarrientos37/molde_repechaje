class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:new, :create, :destroy]
  before_action :authorize_view, only: [:index, :show]
  before_action :authorize_edit, only: [:edit, :update]

  def index
    @employees = if current_user.user_type == 'employee'
      Employee.where(id: current_user.employee.id).page(params[:page])
    else
      Employee.page(params[:page])
    end
  end

  def show
    unless can_view_employee?(@employee)
      redirect_to root_path, alert: 'No autorizado'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to employees_path, alert: 'Empleado no encontrado.'
  end

  def new
    @employee = Employee.new
    @employee.build_user
  end

  def create
    @employee = Employee.new(employee_params)
    selected_user = User.find(employee_params[:user_id])
    @employee.name = selected_user.name
    @employee.position = selected_user.user_type # <- Elimina esta línea
  
    # Asigna position directamente desde los parámetros
    @employee.position = employee_params[:position]
  
    if @employee.save
      selected_user.update(user_type: @employee.position) # <- Actualiza user_type
      redirect_to employees_path, notice: 'Empleado creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      @employee.user.update(user_type: @employee.position) # <- Actualiza user_type
      redirect_to employee_path(@employee), notice: 'Empleado actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: 'Empleado eliminado exitosamente.'
  end

  private

  def authorize_edit
    unless current_user.user_type == 'administrator' || 
           (current_user.user_type == 'manager' && @employee.user.user_type == 'employee')
      redirect_to root_path, alert: 'No autorizado'
    end
  end

  def authorize_view
    unless can_view_employee?(@employee)
      redirect_to root_path, alert: 'No autorizado'
    end
  end

  def can_view_employee?(employee)
    return true if current_user.user_type.in?(['administrator', 'manager'])
    current_user.user_type == 'employee' && current_user.employee == employee
  end

  def employee_params
    base_params = [:birth_date, :hire_date, :position]
    if current_user.user_type == 'administrator'
      params.require(:employee).permit(*base_params, :user_id)
    elsif current_user.user_type == 'manager'
      params.require(:employee).permit(*base_params)
    end
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
