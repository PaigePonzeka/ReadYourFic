class Storyrelation < ActiveRecord::Base
  belongs_to :story
  belongs_to :ship
end
