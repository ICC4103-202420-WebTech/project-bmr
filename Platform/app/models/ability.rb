# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      # Course creators can manage their own courses and associated lessons/questions
      can :manage, Course, user_id: user.id
      can :manage, Lesson, course: { user_id: user.id }
      can :manage, Question, user_id: user.id
      can :enroll, Course

      # Allow users to read any course
      can :read, Course

      # Allow enrolled users to read lessons and questions from the courses they are enrolled in
      can :read, Lesson, course: { id: user.enrolled_courses.pluck(:id) }
      can :read, Question, lesson: { course: { id: user.enrolled_courses.pluck(:id) } }

      # Allow users to enroll in any course
      can :create, Enrollment # Allow any user to create an enrollment

      # Allow users to manage their own enrollments
      can :destroy, Enrollment, user_id: user.id

      # Enrolled users can read and create answers to questions in enrolled courses
      can :read, Answer, question: { lesson: { course: { id: user.enrolled_courses.pluck(:id) } } }
      can :create, Answer, question: { lesson: { course: { id: user.enrolled_courses.pluck(:id) } } }
      
    else
      # Guests (not logged in) can only read courses and access the registration and login pages
      can :read, Course
      can :create, User # Allow guest users to create accounts
    end
  end
end
