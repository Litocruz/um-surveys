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
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def change_class(stateable)  
    estado = stateable.status? ? 'btn btn-mini btn-success' : "btn btn-mini btn-warning"
    estado = stateable.end_date < Time.now ? "btn btn-mini btn-danger" : estado unless stateable.end_date.nil?
    return estado
    Rails.logger.debug "stateable.end_date.nil?: #{stateable.end_date.nil?}"
    Rails.logger.debug "estado: #{estado}"
  end
  def change_title(stateable)  
    estado = stateable.status? ? 'Activa' : 'Inactiva'  
    estado = stateable.end_date < Time.now ? 'Finalizado' : estado unless stateable.end_date.nil?
    return estado
  end

  def link_to_with_icon(stateable, url, options = {})
    clas = stateable.status? ? 'btn-success' : 'btn-warning'
    title = stateable.status? ? 'Activa' : 'Inactiva'
    stateable.end_date < Time.now ? clas = 'btn-danger' : clas unless stateable.end_date.nil?
    options[:class] = options[:class] << ' ' << clas
    options[:title] = title
    link_to glyph(title), url, options
  end
  
  private
    def wrap_long_string(text, max_width = 3)
      zero_width_space = "&#8203;"
        regex = /.{1,#{max_width}}/
        (text.length < max_width) ? text :
        text.scan(regex).join(zero_width_space)
    end
end
