class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      if user.role == "teacher"
        # Teachers can manage their own courses, lessons, questions, and answers
        can :manage, Course, teacher_id: user.id
        can :manage, Lesson, course: { teacher_id: user.id }
        can :manage, Question, lesson: { course: { teacher_id: user.id } }
        can :manage, Answer, question: { lesson: { course: { teacher_id: user.id } } }
        can :read, :my_courses
      elsif user.role == "student"
        # Students can manage their enrolled courses and related content
        can :read, Course, enrollments: { user_id: user.id }
        can :read, Lesson, course: { enrollments: { user_id: user.id } }
        can :enroll, Course
        can :destroy, Enrollment, user_id: user.id
        can :read, :my_courses

        # Students can create and read questions in lessons they are enrolled in
        can :create, Question, lesson: { course: { enrollments: { user_id: user.id } } }
        can :read, Question, lesson: { course: { enrollments: { user_id: user.id } } }

        # Students can create and read answers in lessons they are enrolled in
        can :create, Answer, question: { lesson: { course: { enrollments: { user_id: user.id } } } }
        can :read, Answer, question: { lesson: { course: { enrollments: { user_id: user.id } } } }
      end

      # General permissions for all logged-in users
      can :read, Course
      can :read, Lesson

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
