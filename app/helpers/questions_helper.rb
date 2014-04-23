module QuestionsHelper
	def link_colored(question)
		if question.validation_rules[:presence] == "1"
			link_to question.question_text.truncate(90), [:edit, question.survey, question], style: "color:red"
		else
			link_to question.question_text.truncate(90), [:edit, question.survey, question]
		end
	end	
end