# For automatic update scheduling https://github.com/javan/whenever
# TODO remove themes column from stories
# TODO updating many-to-many tables connected to stories

class StoriesController < ApplicationController
  helper_method :generate_stories
  # GET /stories
  # GET /stories.json
  helper_method :sort_column, :sort_direction

  def index
    #@stories = Story.joins(:characters, :themes, :ships).search(params[:search], params[:character], params[:themes], params[:ships]).order(sort_column + " " + sort_direction).paginate(:page => params[:page],:per_page => 100)
    @stories = Story.joins(:characters, :themes).search(params[:search], params[:character], params[:themes]).order(sort_column + " " + sort_direction).uniq.paginate(:page => params[:page],:per_page => 100)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    generate_stories
    @story = Story.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.json
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  #
  # Crawl FF.net to get the story details
  #
  def generate_stories
    require 'open-uri'
    debug = true
    if !debug
      # Open the first page
       doc = Nokogiri::HTML(open('http://www.fanfiction.net/tv/Glee/'))
          #get the number of pages to scrape
          pages = []
          doc.xpath('//center/a').each do |page|
            pages.push(page.content)
            @pages = pages[pages.length-2].gsub!(',', '').to_i
            #last page is the second to last guy
          end
    end

    # hard coding pages for now to save some time
    # in a for loop from 1 - number of pages
    if debug
      @pages = 4
    end

    (4..@pages).each do |i|
      if debug
        doc= Nokogiri::HTML(open("/Users/paigep/Documents/scraper/test#{i}.html"))
      else
        doc= Nokogiri::HTML(open("http://www.fanfiction.net/tv/Glee/10/0/0/1/0/0/0/0/0/#{i}/"))
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
  # Takes an array of characters, creates a new one if it doesn't exist \
  # Then creates a new protagnist for the link
  #
  def generate_character(story_characters, story)
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
      # If there are two characters, assume a ship, generate a ship relation
      if (story_characters.count == 2)
        characterA = Character.find_by_ff_name(story_character[0])
        characterB = Character.find_by_ff_name(story_character[1])
        relationships_of_a = Relationship.find_by_character_id(characterA.id)
        relationships_of_b = Relationship.find_by_character_id(characterB.id)

        # compare relationships_of_a to relationships_of_b to find if there is a matching ship_id
          # if there is a matching ship_id save that into ship_id
          # TODO there's got to be a faster way to do this

      end
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
      theme = Theme.new()
      theme.name = theme_name
      theme.save
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
      author = Author.new(params[:author])
      author.name = author_name
      author.ff_id = author_ff
    end
    author
  end

  def generate_story(story_content)
    #
    # Check to see if the story exists
    #
    story_item = Story.find_by_ff_id(story_content['ff_id'])
    # check to see if a story with that FF id exists
    if story_item
      # update the story with the current data
      story_item.update_attributes(:title => story_content['title'], :author => story_content['author'], :ff_id => story_content['ff_id'], :summary => story_content['summary'], :complete => story_content['complete'], :language => story_content['language'], :reviews => s_to_num(story_content['reviews']), :chapters => s_to_num(story_content['chapters']), :rating => story_content['rated'],:published => s_to_date(story_content['published']), :words => s_to_num(story_content['words']), :updated =>  s_to_date(story_content['updated']) )

    else
      story = Story.new(params[:story])
      story.title   = story_content['title']
      story.author  = story_content['author']
      story.ff_id   = story_content['ff_id']
      story.summary = story_content['summary']
      story.complete = story_content['complete']
      story.language = story_content['language']
      #story.theme   = story_content['theme']
      story.reviews = s_to_num(story_content['reviews'])
      story.chapters = s_to_num(story_content['chapters'])
      story.rating = story_content['rated']
      story.published = s_to_date(story_content['published'])
      story.words = s_to_num(story_content['words'])
      story.updated = s_to_date(story_content['updated'])
      story.save
      generate_character(story_content['characters'], story)
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

  private


  def sort_column
    Story.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

  end

end
