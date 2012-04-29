class Protagnist < ActiveRecord::Base
  # This is for the many-to-many relation ship between character and stories the name is kind of terrible

  belongs_to :story
  belongs_to :character
end
