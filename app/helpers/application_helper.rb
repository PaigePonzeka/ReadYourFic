module ApplicationHelper

  def story_ff_path(story_id)
    "http://fanfiction.net/story/#{story_id}"
  end

  def author_ff_path(author_id)
    "http://fanfiction.new/author#{author_id}"
  end
end
