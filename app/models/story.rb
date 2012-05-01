class Story < ActiveRecord::Base
  belongs_to :author
  has_many :protagnists
  has_many :characters, :through => :protagnists

  has_many :storyrelations
  has_many :ships, :through => :storyrelations

  has_many :storythemes
  has_many :themes, :through => :storythemes

  serialize :characters_old
  serialize :theme

  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
