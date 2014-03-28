  class QuestionsController < ApplicationController
    #before_filter :authenticate_administrator!
    respond_to :html, :js

    before_filter :find_survey!
    before_filter :find_question!, :only => [:edit, :update, :destroy]
    helper_method :sort_column, :sort_direction

    def index
      @questions = @survey.questions.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 15) 
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

    private
      def find_survey!
        @survey = Survey.find(params[:survey_id])
      end

      def find_question!
        @question = @survey.questions.find(params[:id])
      end

      def index_location
        survey_questions_url(@survey)
      end

      def sort_column
        Question.column_names.include?(params[:sort]) ? params[:sort] : "question_text"   
      end  
     
      def sort_direction
        %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
      end
  end
