class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_many :completed_lessons, dependent: :destroy

  def progress_percentage
    total_lessons = course.lessons.count
    completed = completed_lessons.count
    total_lessons.zero? ? 0 : ((completed.to_f / total_lessons) * 100).round(2) # Calculamos el porcentaje correcto
  end
end
