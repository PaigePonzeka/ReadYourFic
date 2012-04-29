class ShipsController < ApplicationController
  # GET /ships
  # GET /ships.json
  def index
    @ships = Ship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ships }
    end
  end

  # GET /ships/1
  # GET /ships/1.json
  def show
    @ship = Ship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ship }
    end
  end

  # GET /ships/new
  # GET /ships/new.json
  def new
    update_ships
    @ship = Ship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ship }
    end
  end

  # GET /ships/1/edit
  def edit
    @ship = Ship.find(params[:id])
  end

  # POST /ships
  # POST /ships.json
  def create
    @ship = Ship.new(params[:ship])

    respond_to do |format|
      if @ship.save
        format.html { redirect_to @ship, notice: 'Ship was successfully created.' }
        format.json { render json: @ship, status: :created, location: @ship }
      else
        format.html { render action: "new" }
        format.json { render json: @ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ships/1
  # PUT /ships/1.json
  def update
    @ship = Ship.find(params[:id])

    respond_to do |format|
      if @ship.update_attributes(params[:ship])
        format.html { redirect_to @ship, notice: 'Ship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ships/1
  # DELETE /ships/1.json
  def destroy
    @ship = Ship.find(params[:id])
    @ship.destroy

    respond_to do |format|
      format.html { redirect_to ships_url }
      format.json { head :no_content }
    end
  end

  def update_ships
    # A data structure to store the ships in

    # Will and Emma-Wemma
    # Quinn and Puck-Quick
    # Quinn and Rachel-Quichel, Faberry, Achele
    # Puck and Rachel-Puckleberry
    # Finn and Rachel-Finchel
    # Brittany and Santana-Brittana
    # Artie and Mercedes-Artcedes
    # Sam and Mercedes-Samcedes
    # Puck and Finn-Pinn
    # Finn and Kurt-Furt
    # Kurt and Rachel: Hummelberry
    # Kurt and Blaine-Klaine
    # Blaine and Rachel-Blainchel
    # Kurt and Karofsky-Kurtofsky
    # Blaine and Karofsky-Blainofskyve
    # Puck and Artie-Partie
    # Artie and Tina-Artina
    # Kurt and Puck-Puckurt
    # Kurt and Will-Kill
    # Jesse and Rachel-St. Berry
    # Santana and Rachel-Pezberry
    # Puck and Lauren-Pizes
    # Mike and Tina-Tike
    # Artie and BrittanyBartie
    # Santana and Karofsky-Santofsky
    # Sebastian and Blaine-Seblaine
    # Rory and Sam-Sory
    # Rory and Sugar-Flanamotta
    ships = [
            ["Brittana", ["Brittany P.", "Santana L."]],
            ["Faberry", ["Quinn F.", "Rachel B."]],
            ["Quick", ["Quinn F.", "Puck"]]
          ]

    ships.each do |ship_data|
      ship = Ship.find_by_name(ship_data[0])

      # Make sure the ship doesn't already exist
      if !ship
        # create a new ship
        ship = Ship.new()
        ship.name = ship_data[0]
        ship.save

        # characters
        ship_characters = ship_data[1]
        ship_characters.each do |ship_character|
          character = generate_character(ship_character)

          # save the relationship
          relationship = Relationship.new()
          relationship.ship = ship
          relationship.character = character
          relationship.save
        end
      end
    end
  end

  #
  # Find the character based on name, If a character doesn't exist create a new one
  #
  def generate_character(character_name)
    character = Character.find_by_ff_name(character_name)
    # check to see if the character exists
    if !character
      character = Character.new()
      character.ff_name = character_name
      character.save
    end
    character
  end

end
