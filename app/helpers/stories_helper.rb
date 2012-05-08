module StoriesHelper

  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "currents #{sort_direction}" :nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"

    # TODO need to know when to use apersand or a question mark...
    current_url = request.url

    if current_url.split('?')[1] #then there is already parameters just append it
      link_to (content_tag(:span,'' ,:class=>"arrow") + title), "#{current_url}&direction=#{direction}&sort=#{column}", {:class => css_class}
    else # there aren't parameters
      link_to (content_tag(:span,'' ,:class=>"arrow") + title), "#{current_url}?direction=#{direction}&sort=#{column}", {:class => css_class}
    end
  end

  def multiselect_tag(array)
    select_tag(:ships, options_for_select(array), :multiple => true)
  end

end
