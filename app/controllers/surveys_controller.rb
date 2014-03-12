  class SurveysController < ApplicationController
    #before_filter :authenticate_administrator!, except: :index
    before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
    before_action :correct_user,   only: :destroy
    respond_to :html, :js
    respond_to :json, only: :results

    def index
      @surveys = Survey.all
      respond_with(@surveys)
    end

    def new
      @survey = Survey.new
      respond_with(@survey)
    end

    def create
      @survey = current_user.surveys.build(survey_params)
      @survey.save

      respond_with(@survey, location: surveys_url)
    end

    def destroy
      @survey = Survey.find(params[:id])
      @survey.destroy

      respond_with(@survey)
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results = SurveyResults.new(survey: @survey).extract

      respond_with(@survey_results, root: false)
    end

    private
    def survey_params
      if Rails::VERSION::MAJOR == 4
        params.require(:survey).permit(:name)
      else
        params[:survey]
      end
    end
    def correct_user
      @survey = current_user.surveys.find_by(id: params[:id])
      redirect_to root_url if @survey.nil?
    end
  end
