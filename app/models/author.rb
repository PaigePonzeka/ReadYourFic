class Author < ActiveRecord::Base
  has_many :stories
end
