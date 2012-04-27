class Story < ActiveRecord::Base
  belongs_to :author
  serialize :characters
  serialize :theme
end
