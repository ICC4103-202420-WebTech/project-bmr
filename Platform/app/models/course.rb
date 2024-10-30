class Course < ApplicationRecord
  belongs_to :user
  has_many :lessons
  has_many :enrollments
  has_many :users, through: :enrollments

  # Course with the most lessons
  def self.with_most_lessons
    joins(:lessons).group(:id).order('COUNT(lessons.id) DESC').first
  end

  # Course creator with the most courses
  def self.creator_with_most_courses
    joins(:user).group('users.id').order('COUNT(courses.id) DESC').first
  end

  # Last 3 created courses
  def self.recent_courses
    order(created_at: :desc).limit(3)
  end

  # Course with the most current students
  def self.with_most_current_students
    joins(:enrollments).group(:id).order('COUNT(enrollments.id) DESC').first
  end

  # Course most completed by students
  def self.most_completed
    joins(:enrollments).where(enrollments: { progress: 100 })
      .group(:id).order('COUNT(enrollments.id) DESC')
      .select('courses.title, COUNT(lessons.id)')
  end
end
