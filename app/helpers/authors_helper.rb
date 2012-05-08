module AuthorsHelper

  #
  # Getting the total number of reviews
  # for the author's stories
  #
  def total_reviews
    total = 0
    @author.stories.each do |story|
      total += story.reviews
    end
    number_with_delimiter(total, :delimiter => ',')
  end


  #
  # Getting the total number of words
  # for the author's storoes
  #
  def total_words
    total = 0
    @author.stories.each do |story|
      total += story.words
    end
    number_with_delimiter(total, :delimiter => ',')
  end

  def total_chapters
    total = 0
    @author.stories.each do |story|
      total += story.chapters
    end
    number_with_delimiter(total, :delimiter => ',')
  end


  #
  #
  #
  def generate_tag_cloud(author)
    # counting the number of each theme, character and ship
    tags = Array.new
    author.stories.each do |story|
      story.themes.each do |theme|
        tags[theme.name] = 0
      end
      story.characters.each do |character|
        tags[character.ff_name] = 0
      end
      story.ships.each do |ship|
        tags[ship.name] = 0
      end
    end
  end


end
