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




  def self.search(search, characters)
    if search
      where("#{character_query(characters)}")
    # elsif character
    #       where("#{character_query(characters)}")
    else
      scoped
    end

  end

  # TODO add ors for additional characters
  def self.character_query(characters)
    query = "("
    characters.each do |character|
      query += "characters.id = #{character}"
    end
    query +=")"
    query
  end




end
