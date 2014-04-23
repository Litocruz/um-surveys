  class AnswerGroupsController < ApplicationController
    before_filter :find_survey!

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      if params[:answer_group][:url_token] != ""
        participant = @survey.participants.find_by(url_token: params[:answer_group][:url_token])
        if hasnt_voted_participant?
            if @answer_group_builder.save
              participant.update_attributes!(:status => true)
              flash[:success] = "Gracias por votar #{participant.name}!"
              redirect_to root_path
            else
              flash.now[:error] = "Se produjo un error"
              render :new
            end
        else
          flash[:error] = "Ya voto. #{participant.name}"
          redirect_to root_path
        end
      else
        if has_voted?
          flash[:error] = "Usted ya voto"
          redirect_to root_path
        else
          if @answer_group_builder.save
            vote
            flash[:success] = "Gracias por votar!"
            redirect_to root_path
          else
            flash.now[:error] = "Se produjo un error"
            render :new
          end
          
        end
      end
    end

    def hasnt_voted_participant?
        participant = @survey.participants.find_by(url_token: params[:answer_group][:url_token])
        participant[:status] == false
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