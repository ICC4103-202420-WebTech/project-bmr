# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      if user.role == "teacher"
        # Teachers can manage their own courses and lessons
        can :manage, Course, teacher_id: user.id
        can :manage, Lesson, course: { teacher_id: user.id }
        can :manage, Question, user_id: user.id
        can :read, :my_courses
      elsif user.role == "student"
        # Students can read courses and lessons they're enrolled in
        can :read, Course
        can :read, Lesson, course: { id: user.enrolled_courses.pluck(:id) }
        can :enroll, Course
        can :destroy, Enrollment, user_id: user.id
        can :read, :my_courses # Allow students to access the my_courses page

        # Students can read and create answers related to enrolled courses
        can :read, Answer, question: { lesson: { course: { id: user.enrolled_courses.pluck(:id) } } }
        can :create, Answer, question: { lesson: { course: { id: user.enrolled_courses.pluck(:id) } } }
      end

      # General permissions for all logged-in users
      can :read, Course
      can :read, Lesson, course: { id: user.enrolled_courses.pluck(:id) }

      # Restrictions to prevent non-owners from managing unrelated content
      cannot :update, Course, enrollments: { user_id: user.id }
      cannot :destroy, Course, enrollments: { user_id: user.id }
      cannot :manage, Lesson, course: { enrollments: { user_id: user.id } }
    else
      # Permissions for guests
      can :read, Course
      can :create, User # Allow guests to create accounts
    end
  end
end
