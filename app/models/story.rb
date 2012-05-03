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



  # Search for empty search options
  #
  #
  def self.search(search, characters, themes)

    # if search != nil
    #       search_string = "title like \"#{search}\""
    #     end
    if characters
      character_string = "#{make_query(characters, "characters.id")}"
    end

    if themes
      theme_string = "#{make_query(themes, "themes.id")}"
    end

    # if ships
    #      ship_string = "#{make_query(ships, "ships.id")}"
    #    end

    # if character_string && theme_string && ship_string
    #       where("#{character_string} AND #{theme_string} AND #{ship_string}" )
    if character_string && theme_string
      where("#{character_string} AND #{theme_string}" )
    # elsif character_string && ship_string
    #       where("#{character_string} AND #{ship_string}" )
    #     elsif theme_string && ship_string
    #       where("#{theme_string} AND #{ship_string}" )
    elsif character_string
      where(character_string)
    elsif theme_string
      where(theme_string)
    # elsif ship_string
    #       where(ship_string)
    else
      scoped
    end

  end

  #
  # Generating the sql to connect an array
  # of objects through ORs for searches through the database
  #
  def self.make_query(objects, table_column)
     query = "("
      total = objects.count
      count = 1
      objects.each do |object|
        query += "#{table_column} = #{object}"
        if total > 0 && count != total
          query += " OR "
        end
        count+=1
      end
      query +=")"
      query
  end




end
