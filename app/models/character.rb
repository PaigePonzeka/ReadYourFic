class Character < ActiveRecord::Base
  has_many :protagnists
  has_many :stories, :through => :protagnists

  has_many :relationships
  has_many :ships, :through => :relationships

end
