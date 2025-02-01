class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :employee
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :user_type, inclusion: { in: %w[administrator manager employee] }

  before_create :set_first_user_as_admin

  private

  def set_first_user_as_admin
    self.user_type = User.count.zero? ? 'administrator' : 'employee'
  end
end
