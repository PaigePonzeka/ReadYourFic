module ApplicationHelper

  def story_ff_path(story_id)
    "http://fanfiction.net/story/#{story_id}"
  end

  def author_ff_path(author_id)
    "http://fanfiction.new/author#{author_id}"
  end

  def ships_array
    ships = Ship.find(:all)
    ships_array = Array.new
    ships.each do |ship|
      ships_array.push([ship.name, ship.id])
    end
    ships_array
  end

  def characters_array
    characters = Character.find(:all)
    characters_array = Array.new
    characters.each do |character|
      characters_array.push([character.ff_name, character.id])
    end
    characters_array
  end

end
