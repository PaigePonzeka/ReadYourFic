class Relationship < ActiveRecord::Base

  belongs_to :ship
  belongs_to :character
end
