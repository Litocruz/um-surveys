  class AnswerGroupsController < ApplicationController
    before_filter :find_question_group!

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)

      if @answer_group_builder.save
        redirect_to survey_path
      else
        render :new
      end
    end

    private
    def find_question_group!
      @question_group = Survey.find(params[:survey_id])
    end

    def answer_group_params
      answer_params = { params: params[:answer_group] }
      answer_params.merge(user: current_user, survey: @survey)
    end
  end
