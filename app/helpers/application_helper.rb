module ApplicationHelper
	def render_answer_form_helper(answer, form)
      partial = answer.question.type.to_s.split("::").last.downcase
      render partial: "answers/#{partial}", locals: { f: form, answer: answer }
  end

  def checkbox_checked?(answer, option)
    answer.answer_text.to_s.split(",").include?(option)
  end

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end
  
  private
    def wrap_long_string(text, max_width = 3)
      zero_width_space = "&#8203;"
        regex = /.{1,#{max_width}}/
        (text.length < max_width) ? text :
        text.scan(regex).join(zero_width_space)
    end
end
