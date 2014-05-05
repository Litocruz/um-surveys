  class SurveysController < ApplicationController
    #before_filter :authenticate_administrator!, except: :index
    before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
    #before_action :correct_user
    respond_to :html, :js
    respond_to :json, only: [:results, :toggle_status]

    def index
      @surveys = current_user.surveys.paginate(page: params[:page], per_page: 10)
      if current_user.admin?
        @surveys = Survey.paginate(page: params[:page], per_page: 10)
      end
      #@surveys = Survey.all
      respond_with(@surveys)
    end

    def new
      @survey = Survey.new
      respond_with(@survey)
    end

    def create
      @survey = current_user.surveys.build(survey_params)
      if @survey.save
        flash[:success] = "Encuesta creada"
      end
      respond_with(@survey, location: surveys_url)
    end

    def edit
      @survey = Survey.find(params[:id])
    end

    def update
      @survey = Survey.find(params[:id])
      if @survey.update_attributes(survey_params)
        flash[:success] = "Encuesta actualizada"
        respond_with(@survey, location: index_location)
      else
        render 'edit'
      end
    end

    def destroy
      @survey = Survey.find(params[:id])
      if @survey.destroy
        flash[:success] = "Encuesta Eliminada"
      end
      respond_with(@survey)
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results = SurveyResults.new(survey: @survey).extract

      respond_with(@survey_results, root: false)
    end
    def toggle_status
      @survey = Survey.find(params[:id])
      @survey.toggle!(:status)  
      #render nothing: true 
      respond_with(@survey, location: index_location)
    end

    private
      def survey_params
        if Rails::VERSION::MAJOR == 4
          params.require(:survey).permit(:name, :remove_banner, :scope, :code, :start_date, :end_date, :banner)
        else
          params[:survey]
        end
      end
      def index_location
        surveys_url
      end
  end
