class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted? && user.user_type == 'employee'
        Employee.create!(
          user: user,
          name: user.name,
          position: 'employee',
          birth_date: Date.today,
          hire_date: Date.today
        )
      end
    end
  end
end