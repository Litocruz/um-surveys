class Question < ActiveRecord::Base
    
    belongs_to :survey, :inverse_of => :questions
    has_many   :answers

    validates :survey, :question_text, :presence => true
    serialize :validation_rules
    include RankedModel
    ranks :position,with_same: :survey_id,
          class_name: "Question"       # Override the default column, which defaults to the name

    #before_save { |question| question.position =  :position_position, :last  }
    #default_scope order: 'questions.position DESC'


    if Rails::VERSION::MAJOR == 3
      attr_accessible :survey, :question_text, :validation_rules, :answer_options, :title, :description
    end

    def self.inherited(child)
      child.instance_eval do
        def model_name
          Question.model_name
        end
      end

      super
    end

    def rules
      validation_rules || {}
    end

    # answer will delegate its validation to question, and question
    # will inturn add validations on answer on the fly!
    def validate_answer(answer)
      if rules[:presence] == "1"
        answer.validates_presence_of :answer_text
      end

      if rules[:minimum].present? || rules[:maximum].present?
        min_max = { minimum: rules[:minimum].to_i }
        min_max[:maximum] = rules[:maximum].to_i if rules[:maximum].present?

        answer.validates_length_of :answer_text, min_max
      end
    end

    def self.search(search)
      if search
        where('question_text LIKE ?', "%#{search}%")
      else
        where('question_text LIKE ?', "%%")
      end
    end
end
