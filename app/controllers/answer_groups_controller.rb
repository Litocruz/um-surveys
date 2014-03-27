  class AnswerGroupsController < ApplicationController
    before_filter :find_survey!

    def new
      if has_voted_participant?
          Rails.logger.debug "AnswerGroupController status= true"
          flash.now[:error] = "Usted ya voto"
      end
      Rails.logger.debug "AnswerGroupController final"
      participant = @survey.participants.find_by(url_token: params[:url_token])
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      #Rails.logger.debug "AnswerController : #{@answer_group_builder.inspect}"
      if !has_voted_participant?
          participant = @survey.participants.find_by(url_token: params[:url_token])
          Rails.logger.debug "AnswerGroupController status False #{participant.inspect}"
          if @answer_group_builder.save
            participant.update_attributes!(:status => true)
            flash[:success] = "Gracias por votar!"
          else
            flash.now[:error] = "Se produjo un error"
          end
      else
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
            else
              render root_path
            end
          else
            flash.now[:error] = "Se produjo un error"
            render :new
          end
        end
      end
    end

    private
      def has_voted_participant?
        if params[:url_token]
          participant = @survey.participants.find_by(url_token: params[:url_token])
          Rails.logger.debug "AnswerGroupController participant : #{participant.inspect}"
          participant[:status] == true
        end
      end
      def find_survey!
        @survey = Survey.find(params[:survey_id])
      end

      def answer_group_params
        answer_params = { params: params[:answer_group] }
        answer_params.merge(user: current_user, survey: @survey, participant: @survey.participants)
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
