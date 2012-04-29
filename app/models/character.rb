class Character < ActiveRecord::Base
  has_many :protagnists
  has_many :stories, :through => :protagnists

end
