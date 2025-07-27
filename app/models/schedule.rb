class Schedule < ApplicationRecord
  belongs_to :employee, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :shift_type, presence: true

  SHIFT_OPTIONS = {
    'morning' => {
      'monday' => { 'start' => '08:00', 'end' => '17:00' },
      'tuesday' => { 'start' => '08:00', 'end' => '17:00' },
      'wednesday' => { 'start' => '08:00', 'end' => '17:00' },
      'thursday' => { 'start' => '08:00', 'end' => '17:00' },
      'friday' => { 'start' => '08:00', 'end' => '17:00' }
    },
    'evening' => {
      'monday' => { 'start' => '15:00', 'end' => '24:00' },
      'tuesday' => { 'start' => '15:00', 'end' => '24:00' },
      'wednesday' => { 'start' => '15:00', 'end' => '24:00' },
      'thursday' => { 'start' => '15:00', 'end' => '24:00' },
      'friday' => { 'start' => '15:00', 'end' => '24:00' }
    }
  }

  before_save :set_work_hours

  private

  def set_work_hours
    self.work_hours = SHIFT_OPTIONS[shift_type] if shift_type.present?
  end

  def creator_must_be_admin
    unless user&.user_type == 'administrator'
      errors.add(:base, 'Solo administradores pueden crear horarios')
    end
  end
end
