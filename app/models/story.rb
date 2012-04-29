class Story < ActiveRecord::Base
  belongs_to :author
  has_many :protagnists
  has_many :characters, :through => :protagnists

  serialize :characters_old
  serialize :theme




end
