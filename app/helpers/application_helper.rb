module ApplicationHelper

  def story_ff_path(story_id)
    "http://fanfiction.net/s/#{story_id}"
  end

  def author_ff_path(author_id)
    "http://fanfiction.new/u/#{author_id}"
  end

  def ships_array
    ships = Ship.order("name ASC").find(:all)
    ships_array = Array.new
    ships.each do |ship|
      ships_array.push([ship.name, ship.id])
    end
    ships_array
  end

  def characters_array
    characters = Character.order("ff_name ASC").find(:all)
    characters_array = Array.new
    characters.each do |character|
      characters_array.push([character.ff_name, character.id])
    end
    characters_array
  end

  def themes_array
    themes = Theme.order("name ASC").find(:all)
    themes_array = Array.new
    themes.each do |theme|
      themes_array.push([theme.name, theme.id])
    end
    themes_array
  end

end
