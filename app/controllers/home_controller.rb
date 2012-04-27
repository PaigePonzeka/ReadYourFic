#rails generate scaffold Story title:string ff_id:integer author_id:integer summary:text rating:string language:string theme:text chapters:integer words:integer reviews:integer complete:boolean characters:text published:date updates:date
class HomeController < ApplicationController

  def index

  end

end