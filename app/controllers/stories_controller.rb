class StoriesController < ApplicationController
  helper_method :generate_stories
  # GET /stories
  # GET /stories.json
  def index
    generate_stories
    @stories = Story.all

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
        @result = Story.new(params[:story])
        # get an array of the all the links
        links = Array.new
        node.xpath('./a').each do |link_node|
          links.push(link_node)
        end
         # the first link is the title
         @result.title = links[0].content
         #@result['story_url'] = links[0]['href']

         # get story id
         url_split = links[0]['href'].split('/')
         @result.ff_id = url_split[url_split.length-3]

         # the last link is reviews link or the author link
         last_link = links[links.length-1]
         # remove the link if its a review link
         if ((last_link.content <=> "reviews") == 0)
           # remove it and do it again
           links.pop()
           last_link = links[links.length-1]
         end


        # Creating and saving author
        @author = Author.new(params[:author])
        @author.name = last_link.content
        author_url_split = last_link['href'].split('/')
        @author.ff_id = author_url_split[author_url_split.length-2]
        @author.save
        @result.author = @author.id

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
            tags[detail_split[0]] = detail_split[1]
          else# we need to do something differnt
            # complete status
            if ((detail_split[0] <=> "Complete") == 0)
              tags[detail_split[0]] = true
              @result.complete = true
            # language
            elsif count == 2
              tags["Language"] = detail_split[0]
              @result.language = true
            # Theme
            elsif count == 3
              tags["Theme"] = detail_split[0].split("/")
              @result.theme = detail_split[0].split("/")
            # Main Characters
            elsif count == 9
              tags["Characters"] = detail_split[0].split(" & ")
              @result.characters = detail_split[0].split(" & ")

            end

          end
          count+=1
        end

        # get the summary
        node.xpath('./div').each do |summary_node|
           #@result["summary"] = summary_node.content
           @result.summary = summary_node.content
        end

        #@result["tags"] = tags
        @result.save
        #@results.push(@result)
      end
    end



  end

end
