module QuestionsHelper
	def link_colored(question,defaults={})
		color = if question.validation_rules[:presence] == "1"
			{ class: 'label-survey-red'}
		else
			{ class: 'label-survey' }			
		end
		defaults.merge(color)
	end
end