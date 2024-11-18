class CompletedLesson < ApplicationRecord
  belongs_to :enrollment
  belongs_to :lesson

  validates :enrollment_id, uniqueness: { scope: :lesson_id, message: "Lesson already marked as completed for this enrollment" }
end
