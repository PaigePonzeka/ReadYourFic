class Story < ActiveRecord::Base
  belongs_to :author
  has_many :protagnists
  has_many :characters, :through => :protagnists
  has_many :storyrelations
  has_many :ships, :through => :storyrelations

  serialize :characters_old
  serialize :theme




end
