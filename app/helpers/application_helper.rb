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

  def human_boolean(boolean)
    boolean ? 'Si' : 'No'
  end

  @@data_per_page = 3
  
  def sortable(column, title = nil)
    title ||= column.titleize
    column_css = nil
    direction = "asc"

    if column == sort_column
      direction_css = "headerSortUp"
      
      if sort_direction == "asc"
        direction_css = "headerSortDown"
        direction = "desc"
      end
      
      column_css = column == sort_column ? "header #{direction_css}" : nil      
    end

    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => column_css}
  end
  
  private
    def wrap_long_string(text, max_width = 3)
      zero_width_space = "&#8203;"
        regex = /.{1,#{max_width}}/
        (text.length < max_width) ? text :
        text.scan(regex).join(zero_width_space)
    end
end
