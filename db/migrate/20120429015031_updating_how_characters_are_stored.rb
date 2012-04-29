class UpdatingHowCharactersAreStored < ActiveRecord::Migration
  def up

    stories = Story.find(:all)
    # for ever characters in a story

    stories.each do |story|
      story_characters = story.characters_old
      if story_characters
        story_characters.each do |story_character|

          character = Character.find_by_ff_name(story_character)
          if !character # if the character doesn't exist add it
            character = Character.new()
            character.ff_name = story_character
            character.save
          end

          # create a new protagnist link
          protagnist = Protagnist.new()
          protagnist.character = character
          protagnist.story = story
          protagnist.save
        end
      end
    end
  end

  def down
  end
end
