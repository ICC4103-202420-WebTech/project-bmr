class AnswersController < ApplicationController
    load_and_authorize_resource
  
    def create
      @question = Question.find(params[:question_id])
      @answer = @question.answers.build(answer_params.merge(user: current_user))
  
      if @answer.save
        redirect_to course_lesson_path(@question.lesson.course, @question.lesson), notice: 'Answer posted successfully.'
      else
        redirect_to course_lesson_path(@question.lesson.course, @question.lesson), alert: 'Failed to post answer.'
      end
    end
  
    def destroy
      @answer = Answer.find(params[:id])
      @answer.destroy
      redirect_back fallback_location: root_path, notice: 'Answer deleted successfully.'
    end
  
    private
  
    def set_question
      @question = Question.find(params[:question_id])
    end
  
    def answer_params
      params.require(:answer).permit(:content)
    end
  end
