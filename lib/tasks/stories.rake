namespace :db do

  # run with rake lib/tasks/stories.rake db:update_ships
  task :update_ships => :environment do
    puts "Updating Ships"
    update_ships
  end

  # run with rake lib/tasks/stories.rake db:update_stories
  task :update_stories => :environment do
    puts "Updating Stories"
    generate_stories
  end

#
# Crawl FF.net to get the story details
#
def generate_stories
  require 'open-uri'
  debug = false

  if !debug

    # Open the first page To get the page numbers
     doc = Nokogiri::HTML(open('http://www.fanfiction.net/tv/Glee/'))
        #get the number of pages to scrape
        pages = []
        doc.xpath('//center/a').each do |page|
          pages.push(page.content)
          @pages = pages[pages.length-2].gsub!(',', '').to_i
          #last page is the second to last linked page
        end
  end

  # hard coding pages for now to save some time
  # in a for loop from 1 - number of pages
  if debug
    puts "Debugging Mode Enabled"
    @pages = 4
  end

  (200..500).each do |i|
    if debug
      doc= Nokogiri::HTML(open("/Users/paigep/Documents/scraper/test#{i}.html"))
    else
      begin
        doc= Nokogiri::HTML(open("http://www.fanfiction.net/tv/Glee/10/0/0/1/0/0/0/0/0/#{i}/"))
      rescue
        print "Connection failed: #{$!}\n On Page: #{i}"
      next

    end

    doc.xpath('//div[@class = "z-list"]').each do |node|

      story_content = Hash.new

      # get an array of the all the links
      links = Array.new
      node.xpath('./a').each do |link_node|
        links.push(link_node)
      end
       # the first link is the title
       story_content["title"] = links[0].content

       # get story id
       url_split = links[0]['href'].split('/')
       story_content['ff_id'] = url_split[url_split.length-3]

       # the last link is reviews link or the author link
       last_link = links[links.length-1]
       # remove the link if its a review link
       if ((last_link.content <=> "reviews") == 0)
         # remove it and do it again
         links.pop()
         last_link = links[links.length-1]
       end

       # Set the author
      author_name = last_link.content
      author_url_split = last_link['href'].split('/')
      author_ff_id = author_url_split[author_url_split.length-2]
      story_content['author'] = generate_author(author_name, author_ff_id)

      # get the gray section (details)
      gray = ""
      node.xpath('./div//div').each do |div_node|
         gray=div_node.content
         # remove the node for the summary later
         div_node.remove
      end

      details = gray.split(" - ")

      tags = Hash.new
      # split each of those by :
      count = 1
      story_content['reviews'] = '0'
      details.each do |detail|
        detail_split = detail.split(":")
        # If there is nothing in the second one that it isn't a set
        if(detail_split[1] != nil)
          story_content[detail_split[0].downcase] = detail_split[1].strip
        else# we need to do something differnt
          # complete status
          if ((detail_split[0] <=> "Complete") == 0)
            story_content['complete'] = true
          # language
          elsif count == 2
            story_content['language'] = detail_split[0]
          # Theme
          elsif count == 3
            story_content['theme'] = detail_split[0].split("/")
          end

          # Main Characters
          if (count == details.length)
            if (details[details.length-1] <=> "Complete") != 0
              # story isn't complete characters are the last one (or published)
              detail_split = detail.split(":")
              if !detail_split[1] # Not published there are no characters
                story_content['characters'] = detail_split[0].split(" & ")
              end
            else
              # story is complete characters are the second to last one
              detail_split = details[details.length-2].split(":")
              if !detail_split[1] # Not published there are no characters
                story_content['characters'] = details[details.length-2].split(" & ")
              end
            end
          end

          # defaulting to false if complete isn't set
          if story_content['complete'] != true
            story_content['complete'] = false
          end
        end
        count+=1
      end

      # get the summary
      node.xpath('./div').each do |summary_node|
         story_content['summary'] = summary_node.content
      end

      generate_story(story_content)
    end
  end



end



#
# Find the character based on name, If a character doesn't exist create a new one
#
def generate_character(character_name)
  character = Character.find_by_ff_name(character_name)
  # check to see if the character exists
  if !character
    character = Character.new()
    character.ff_name = character_name
    character.save
  end
  character
end


#
# Takes an array of characters, creates a new one if it doesn't exist \
# Then creates a new protagnist for the link
#
def generate_characters(story_characters, story)
    if story_characters
      story_characters.each do |story_character|

        character =generate_character(story_character)
        # create a new protagnist link
        protagnist = Protagnist.new()
        protagnist.character = character
        protagnist.story = story
        protagnist.save
      end
    end

    generate_ship(story_characters, story)
end


#
# Generates a ship from a story with 2+ characters
#
def generate_ship(story_characters, story)

  # If there are two characters, assume a ship, generate a ship relation
  if (story_characters && story_characters.length == 2)
    characterA = Character.find_by_ff_name(story_characters[0])
    characterB = Character.find_by_ff_name(story_characters[1])
    # find the ship with each character
    ships = Ship.joins(:characters).where("characters.id = #{characterA.id}")

    ships.each do |ship|
      ship.characters.each do |character|
        if character.id == characterB.id
          generate_log("Attaching #{ship.name} To #{story.title} Based on Character Tags  #{characterB.ff_name} & #{characterA.ff_name}")
          # attach the ship to the story
          storyrelation = Storyrelation.new()
          storyrelation.story = story
          storyrelation.ship = ship
          storyrelation.save
          return
        end

      end
    end
  end

    # compare relationships_of_a to relationships_of_b to find if there is a matching ship_id
      # if there is a matching ship_id save that into ship_id
      # TODO there's got to be a faster way to do this
end
#
# For every theme in the story theme array generate a new
# theme connection
#
def generate_story_themes(themes, story)
  if themes
    themes.each do |theme|
      theme_obj = generate_theme(theme)
      story_theme = Storytheme.new()
      story_theme.story = story
      story_theme.theme = theme_obj
      story_theme.save
    end
  end
end


#
# If a theme already exists return the connection
# Otherwise create a new theme
#
def generate_theme(theme_name)
  theme = Theme.find_by_name(theme_name)
  if !theme #theme doesn't exist, create a new one
    generate_log("Generating a New Theme: #{theme_name}")
    theme = Theme.new()
    theme.name = theme_name
    theme.save
  else
    generate_log("Theme Exists: #{theme_name}")
  end
  theme
end


#
# If an author already exists just reutnr that author
# Otherwise create a new author
#
def generate_author(author_name, author_ff)
  author = Author.find_by_name(author_name)
  if !author # if it doesn't exist, add it
    generate_log("Generating New Author: #{author_name}")
    author = Author.new()
    author.name = author_name
    author.ff_id = author_ff
  else
    generate_log("Author Exists: #{author_name}")
  end
  author
end


#
# Add a New story row if it doesn't already exist
# otherwise update it
#
def generate_story(story_content)
  #
  # Check to see if the story exists
  #
  story_item = Story.find_by_ff_id(story_content['ff_id'])
  # check to see if a story with that FF id exists
  if story_item
    # update the story with the current data
    generate_log("Updating Story: #{story_content['title']}", true)
    story_item.update_attributes(:title => story_content['title'],  :ff_id => story_content['ff_id'], :summary => story_content['summary'], :complete => story_content['complete'], :language => story_content['language'], :reviews => s_to_num(story_content['reviews']), :chapters => s_to_num(story_content['chapters']), :rating => story_content['rated'],:published => s_to_date(story_content['published']), :words => s_to_num(story_content['words']), :updated =>  s_to_date(story_content['updated']) )

  else

    story = Story.new()
    generate_log("Generating New Story: #{story_content['title']}" , true)
    story.title   = story_content['title']
    story.author  = story_content['author']
    story.ff_id   = story_content['ff_id']
    story.summary = story_content['summary']
    story.complete = story_content['complete']
    story.language = story_content['language']
    story.reviews = s_to_num(story_content['reviews'])
    story.chapters = s_to_num(story_content['chapters'])
    story.rating = story_content['rated']
    story.published = s_to_date(story_content['published'])
    story.words = s_to_num(story_content['words'])
    story.updated = s_to_date(story_content['updated'])
    story.save
    generate_characters(story_content['characters'], story)
    generate_story_themes(story_content['theme'], story)

  end

end

def s_to_num(s)
  if s
    s_num = s.gsub!(',','')
    if s_num
      s = s_num.to_i
    else
      s = s.to_i
    end
  end
  s
end

def s_to_date(s)
  if s
    s = Date.strptime(s, "%m-%d-%y")
  end
  s
end

#
# TODO generate actually log details
#
def generate_log(message, start = false)
  if start
    puts "#{message}"
  else
    puts "\t#{message}"
  end
end

#
# Stores a datastructure with the list of the current ships
#
def update_ships
  # A data structure to store the ships in

  ships = [
          ["Brittana", ["Brittany P.", "Santana L."]],
          ["Faberry", ["Quinn F.", "Rachel B."]],
          ["Flanamotta", ["Rory F.", "Sugar"]],
          ["Sory", ["Rory F.", "Sam E."]],
          ["Seblaine", ["Sebastian S.", "Blaine A."]],
          ["Santofsky", ["D. Karofsky", "Santana L."]],
          ["Bartie", ["Brittany P.", "Artie A."]],
          ["Tike", ["Mike C.", "Tina C."]],
          ["Pezberry", ["Santana L.", "Rachel B."]],
          ["Pizes", ["Lauren Z.", "Puck"]],
          ["St. Berry", ["Jesse sJ.", "Rachel B."]],
          ["Kill", ["Kurt H.", "Will S."]],
          ["Puckurt", ["Kurt H.", "Puck"]],
          ["Artina", ["Tina C.", "Artie A."]],
          ["Partie", ["Puck", "Artie A."]],
          ["Blainofskyve", ["Blaine A.", "D. Karofsky"]],
          ["Klaine", ["Kurt H.", "Blaine A."]],
          ["Hummelberry", ["Kurt H.", "Rachel B."]],
          ["Furt", ["Kurt H.", "Finn H."]],
          ["Pinn", ["Puck", "Finn H."]],
          ["Samcedes", ["Sam E.", "Mercedes J."]],
          ["Artcedes", ["Artie A.", "Mercedes J."]],
          ["Finchel", ["Finn H.", "Rachel B."]],
          ["Puckleberry", ["Puck", "Rachel B."]],
          ["Wemma", ["Will S.", "Emma P."]]
        ]

  ships.each do |ship_data|
    ship = Ship.find_by_name(ship_data[0])

    # Make sure the ship doesn't already exist
    if !ship

      # create a new ship
      ship = Ship.new()
      ship.name = ship_data[0]
      ship.save

      # For each character in the ship
      ship_characters = ship_data[1]
      generate_log("Generating New Ship: #{ship_data[0]} between #{ship_data[1]}")
      ship_characters.each do |ship_character|
        character = generate_character(ship_character)
        # Save the relationship
        relationship = Relationship.new()
        relationship.ship = ship
        relationship.character = character
        relationship.save

      end
    else
      ship.update_attributes(:name => ship_data[0])
      ship.save
      generate_log("Updating: #{ship_data[0]} between #{ship_data[1]}")


    end
  end
end


end