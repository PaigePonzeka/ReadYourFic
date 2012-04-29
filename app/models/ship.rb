class Ship < ActiveRecord::Base
  has_many :relationships
  has_many :characters, :through => :relationships

  has_many :storyrelations
  has_many :stories, :through => :storyrelations
end
