#rails generate scaffold Story title:string ff_id:integer author_id:integer summary:text rating:string language:string theme:text chapters:integer words:integer reviews:integer complete:boolean characters:text published:date updates:date
class HomeController < ApplicationController
  helper_method :my_shared_method

  def my_shared_method
    3
  end
  def index
    # open the first page


        # run the script

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
    @pages = my_shared_method
    # in a for loop from 1 - number of pages
    (1..@pages).each do |i|
      #doc= Nokogiri::HTML(open("http://www.fanfiction.net/tv/Glee/3/0/0/1/0/0/0/0/0/#{i}/"))
      doc= Nokogiri::HTML(open("/Users/paigep/Documents/scraper/test.html"))
      doc.xpath('//div[@class = "z-list"]').each do |node|
        @result = Hash.new
        # get an array of the all the links
        links = Array.new
        node.xpath('./a').each do |link_node|
          links.push(link_node)
        end
         # the first link is the title
         @result['title'] = links[0].content
         #@result['story_url'] = links[0]['href']

         # get story id
         url_split = links[0]['href'].split('/')
         @result['story_id'] = url_split[url_split.length-3]

         # the last link is reviews link or the author link
         last_link = links[links.length-1]
         # remove the link if its a review link
         if ((last_link.content <=> "reviews") == 0)
           # remove it and do it again
           links.pop()
           last_link = links[links.length-1]
         end
        @result['author'] = last_link.content
        #@result['author_url'] = last_link['href']
        # get the author id
        author_url_split = last_link['href'].split('/')
        @result['author_id'] = author_url_split[author_url_split.length-2]


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
            # language
            elsif count == 2
              tags["Language"] = detail_split[0]
            # Theme
            elsif count == 3
              tags["Theme"] = detail_split[0].split("/")
            # Main Characters
            elsif count == 9
              tags["Characters"] = detail_split[0].split(" & ")
            end

          end
          count+=1
        end

        # get the summary
        node.xpath('./div').each do |summary_node|
           @result["summary"] = summary_node.content
        end

        @result["tags"] = tags

        @results.push(@result)
      end
    end



  end
end