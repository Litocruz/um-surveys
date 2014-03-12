  class SurveyResults < BaseService
    attr_accessor :survey

    # extracts question along with results
    # each entry will have the following:
    # 1. question type and question id
    # 2. question text
    # 3. if aggregatable, return each option with value
    # 4. else return an array of all the answers given
    def extract
      @survey.questions.collect do |question|
        results =
          case question
          when Questions::Select, Questions::Radio,
            Questions::Checkbox
            answers = question.answers.map(&:answer_text).map { |text| text.split(',') }.flatten
            answers.inject(Hash.new(0)) { |total, e| total[e] += 1; total }

          when Questions::Short, Questions::Date,
            Questions::Long, Questions::Numeric
            question.answers.pluck(:answer_text)
          end

        QuestionResult.new(question: question, results: results)
      end
    end
  end
