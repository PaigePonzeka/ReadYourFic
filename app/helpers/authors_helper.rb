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
end
