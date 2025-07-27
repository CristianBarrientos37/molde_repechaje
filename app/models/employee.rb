class Employee < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :schedules, dependent: :delete_all

  # Add Kaminari pagination
  paginates_per 10

  accepts_nested_attributes_for :user
  
  validates :name, presence: true
  validates :birth_date, presence: true
  validates :position, presence: true
  validates :hire_date, presence: true
end
