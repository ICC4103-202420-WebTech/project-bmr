class User < ApplicationRecord
  has_many :courses
  has_many :enrollments
  has_many :questions
  has_many :answers
  has_many :enrolled_courses, through: :enrollments, source: :course
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Student with the most enrolled courses
  def self.with_most_enrolled_courses
    joins(:enrollments).group(:id).order('COUNT(enrollments.id) DESC').first
  end
  # Student with the most progress on a course
  def self.with_most_progress_on_course
    Enrollment.order(progress: :desc).first.user
  end
end
