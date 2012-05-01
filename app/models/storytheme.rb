class Storytheme < ActiveRecord::Base

  belongs_to :story
  belongs_to :theme
end
