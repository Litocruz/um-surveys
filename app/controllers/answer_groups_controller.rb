  class AnswerGroupsController < ApplicationController
    before_filter :find_survey!

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      #Rails.logger.debug 'DEBUG: @answer_group_builder ' + debug(@answer_group_builder.to_s)
     
      if has_voted?
        flash.now[:error] = "Usted ya voto"
        render :new
        return
      else
        if @answer_group_builder.save
          vote
          flash[:success] = "Gracias por votar!"
          if signed_in?
            redirect_to surveys_path 
          end
        else
          flash.now[:error] = "Se produjo un error"
          render :new
        end
      end
    end

    private
      def find_survey!
        @survey = Survey.find(params[:survey_id])
      end

      def answer_group_params
        answer_params = { params: params[:answer_group] }
        answer_params.merge(user: current_user, survey: @survey)
      end
      def vote
        vote_token = AnswerGroup.create_vote_token(@survey.id)
        id = "vote_token_" + @survey.id.to_s
        cookies.permanent[id] = vote_token
      end
      def has_voted?
        id = "vote_token_" + @survey.id.to_s
        !cookies[id].nil?
      end
  end
