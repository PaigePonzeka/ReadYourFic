class Theme < ActiveRecord::Base

  has_many :storythemes
  has_many :stories, :through => :storythemes
end
