class Ship < ActiveRecord::Base
  has_many :relationships
  has_many :characters, :through => :relationships
end
