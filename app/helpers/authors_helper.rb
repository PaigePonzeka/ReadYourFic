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
    tags = Hash.new
    total_tags = 0
    author.stories.each do |story|

      story.themes.each do |theme|
        total_tags+=1
        if tags[theme.name]
          tags[theme.name] += 1
        else
          tags[theme.name] = 1
        end
      end

      story.characters.each do |character|
        total_tags+=1
        if tags[character.ff_name]
          tags[character.ff_name] += 1
        else
          tags[character.ff_name] = 1
        end
      end

      story.ships.each do |ship|
        total_tags+=1
        if tags[ship.name]
          tags[ship.name] += 1
        else
          tags[ship.name] = 1
        end
      end
    end
    tags = tags.sort{|a,b| a[1] <=> b[1]}

    # name: tag-name, weight: weight-class
    # how to determine what class the tags get? 6 difference sizes
    # xxs, xs, s, l, xl,xxl
    # divide the count into 6 each 6 get a size starting with small -> large
    # want to favor smaller tags over larger ones
    # don't want to completely ignore small tags
    # calculate totally tags and determine size based on percentage of tags
    # 100/percentage
    # keep the tag cloud reasonable
    tags.each do |tag|
      tag_weight = tag[1]/total_tags.to_f
      if tag_weight <= (0.05) #.xxs
         tag[1] = "xxs"
      elsif tag_weight <= (0.10) #.xs
        tag[1] = "xs"
      elsif tag_weight <= (0.30) #.s
        tag[1] = "s"
      elsif tag_weight <= (0.40) #.l
        tag[1] = "l"
      elsif tag_weight <= (0.75) #.xl
        tag[1] = "xl"
      elsif tag_weight >= (0.90) #.xxl
        tag[1] = "xxl"
      end
    end
    tags

  end

end
