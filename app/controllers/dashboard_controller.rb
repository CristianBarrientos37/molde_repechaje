class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.user_type == 'employee'
      if current_user.employee.nil?
        flash[:alert] = 'No se encontró el empleado asociado'
        return
      end
    elsif current_user.user_type == 'administrator'
      @total_employees = Employee.count
    elsif current_user.user_type == 'manager'
      @managed_employees = Employee.where(position: 'employee')
    end
  end
end
