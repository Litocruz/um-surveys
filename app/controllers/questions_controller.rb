  class QuestionsController < ApplicationController
    #before_filter :authenticate_administrator!
    before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
    respond_to :html, :js

    before_filter :find_survey!, :only => [:index, :new, :create, :reorder]
    before_filter :find_question!, :only => [:edit, :update, :destroy]
    

    def index
      @questions = @survey.questions.rank(:position).paginate(:page => params[:page], :per_page => 10) 
      respond_with(@questions)
    end

    def new
      @question = QuestionForm.new(:survey => @survey)
      respond_with(@question)
    end

    def create
      form_params = params[:question].merge(:survey => @survey)
      @question = QuestionForm.new(form_params)
      
      #Rails.logger.debug 'DEBUG: question.save ' + @question.save
      if @question.save
        respond_with(@question, location: index_location)
        flash[:success] = "Pregunta Creada"
      else
        respond_with(@question, location: index_location)
      end
    end

    def edit
      @question = QuestionForm.new(:question => @question)
      respond_with(@question)
    end

    def update
      form_params = params[:question].merge(:question => @question)
      @question = QuestionForm.new(form_params)
      if @question.save
        flash[:success] = "Pregunta Actualizada"
      end
      respond_with(@question, location: index_location)
    end

    def destroy
      if @question.destroy
        flash[:success] = "Pregunta eliminada"
      end
      respond_with(@question, location: index_location)
    end
  
    def reorder
      @question = @survey.questions.find(params[:id])
      #if question
        @question.attributes = question_params
        @question.save
      #end

      # .attributes is a useful shorthand for mass-assigning
      # values via a hash
      #@question.attributes = question_params
      #Rails.logger.debug "@question.save.inspect: #{@question.save}"
      #@question.save

      # this action will be called via ajax
      render nothing: true
    end

    private
      def question_params
       params.require(:question).permit(:question, :position_position, :position)
      end
      def find_survey!
        @survey = Survey.find(params[:survey_id])
      end

      def find_question!
        @question = @survey.questions.find(params[:id])
      end

      def index_location
        survey_questions_url(@survey)
      end
  end
