class StoriesController < ApplicationController
  helper_method :generate_stories
  # GET /stories
  # GET /stories.json
  def index
    #generate_stories
    @stories = Story.all(:order => "title ASC")

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
    @results = []

    # v
    require 'open-uri'
    # Open the first page
    # doc = Nokogiri::HTML(open('http://www.fanfiction.net/tv/Glee/'))
    #     # get the number of pages to scrape
    #     pages = []
    #     doc.xpath('//center/a').each do |page|
    #       pages.push(page.content)
    #       @pages = pages[pages.length-2].gsub!(',', '').to_i
    #       #last page is the second to last guy
    #     end

    # hard coding pages for now to save some time
    @pages = 3
    # in a for loop from 1 - number of pages
    (1..@pages).each do |i|
      #doc= Nokogiri::HTML(open("http://www.fanfiction.net/tv/Glee/3/0/0/1/0/0/0/0/0/#{i}/"))
      doc= Nokogiri::HTML(open("/Users/paigep/Documents/scraper/test.html"))
      doc.xpath('//div[@class = "z-list"]').each do |node|

        story_content = Hash.new

        # get an array of the all the links
        links = Array.new
        node.xpath('./a').each do |link_node|
          links.push(link_node)
        end
         # the first link is the title
         story_content["title"] = links[0].content
         #@result['story_url'] = links[0]['href']

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
        details.each do |detail|
          detail_split = detail.split(":")
          # If there is nothing in the second one that it isn't a set
          if(detail_split[1] != nil)
            story_content[detail_split[0].downcase] = detail_split[1]
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
                # story isn't complete characters are the last one
                story_content['characters'] = detail_split[0].split(" & ")
              else
                # story is complete characters are the second to last one
                story_content['characters'] = details[details.length-2].split(" & ")
              end
            end


          end
          count+=1
        end

        # get the summary
        node.xpath('./div').each do |summary_node|
           #@result["summary"] = summary_node.content
           story_content['summary'] = summary_node.content
        end

        generate_story(story_content)
      end
    end



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

      # TODO need to upgrade words data type
      # TODO converting published and updated to actual dates datatypes
      # TODO default completed to false
      # TODO using helpers to generate author and story url
      # TODO button to run the script
      # TODO button to clear the database
      # TODO updating the database instead of replacing data
    else
      story = Story.new(params[:story])
      story.title   = story_content['title']
      story.author  = story_content['author']
      story.ff_id   = story_content['ff_id']
      story.summary = story_content['summary']
      story.complete = story_content['complete']
      story.language = story_content['language']
      story.theme   = story_content['theme']
      story.characters = story_content['characters']
      story.reviews = story_content['reviews']
      story.chapters = story_content['chapters']
      story.rating = story_content['rated']
      story.published = story_content['published']
      story.words = story_content['words']
      story.updates = story_content['updated']
      story.save
    end
  end


end
