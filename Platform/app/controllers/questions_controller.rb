class QuestionsController < ApplicationController
    before_action :set_lesson
    load_and_authorize_resource
  
    def create
      @question = @lesson.questions.build(question_params.merge(user: current_user))
      if @question.save
        redirect_to course_lesson_path(@lesson.course, @lesson), notice: 'Question posted successfully.'
      else
        redirect_to course_lesson_path(@lesson.course, @lesson), alert: 'Failed to post question.'
      end
    end
  
    private
  
    def set_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end
  
    def question_params
      params.require(:question).permit(:content)
    end
  end
