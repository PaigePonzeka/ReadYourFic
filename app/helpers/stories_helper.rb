module StoriesHelper

  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = column == sort_column ? "currents #{sort_direction}" :nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def multiselect_tag(array)
    select_tag(:city_id, options_for_select(array), :multiple => true)
  end

end
