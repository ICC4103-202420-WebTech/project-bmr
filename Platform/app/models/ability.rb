# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed-in user here. For example:
    user ||= User.new # guest user (not logged in)

    # Any logged-in user
    if user.persisted?
      # Course creators can manage their own courses and associated lessons/questions
      can :manage, Course, user_id: user.id
      can :manage, Lesson, course: { user_id: user.id }
      can :manage, Question, user_id: user.id
      # Enrolled users
      can :read, Course, id: user.enrolled_courses.pluck(:id)
      can :read, Lesson, course: { id: user.enrolled_courses.pluck(:id) }
      can :create, Question, lesson: { course: { id: user.enrolled_courses.pluck(:id) } }
      can :read, Question, lesson: { course: { id: user.enrolled_courses.pluck(:id) } }
      
      # Enrollments: users can enroll and unenroll from courses
      can [:create, :destroy], Enrollment, user_id: user.id
      # Guests can only read courses (index and show)
      can :read, Course
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
