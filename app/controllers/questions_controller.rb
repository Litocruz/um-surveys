  class QuestionsController < ApplicationController
    #before_filter :authenticate_administrator!
    before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
    respond_to :html, :js

    before_filter :find_survey!, :only => [:index, :new, :create, :reorder, :edit, :update, :destroy]
    before_filter :find_question!, :only => [:edit, :update, :destroy]
    

    def index
      @questions = @survey.questions.rank(:position).paginate(:page => params[:page], :per_page => 10)
      @survey_name = @survey.name 
      respond_with(@questions,@survey_name)
    end

    def new
      @question = QuestionForm.new(:survey => @survey)
      respond_with(@question)
    end

    def create
      form_params = params[:question].merge(:survey => @survey)
      @question = QuestionForm.new(form_params)
      
      if @question.save
        Rails.logger.debug "index_location: #{index_location}"
        Rails.logger.debug "params[:commit_new]: #{params[:commit_new]}"
        respond_with(@question, location: params[:commit_new].blank? ? index_location : new_survey_question_url )
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
        flash.now[:success] = "Pregunta eliminada"
      end
      respond_with(@question, location: index_location)
    end

    def destroy_multiple
      @questions=Question.destroy_all(id: params[:questions_ids])
      if @questions == []
        flash[:error] = "No se seleccionaron preguntas"
      else
        flash[:success] = "Preguntas Eliminadas"
      end
      respond_with do |format|
        format.html { redirect_to survey_questions_path }
        format.json { head :no_content }
      end
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

    def clone_question
      @question_old = Question.find(params[:id])

      @question=@question_old.dup

      if @question.save     
        flash.now[:success] = "Pregunta clonada"
        respond_with(@question_old)
      else
        flash.now[:error] = "Se produjo un error en clonacion de la Pregunta"
      end
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
