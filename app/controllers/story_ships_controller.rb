class StoryShipsController < ApplicationController
  # GET /story_ships
  # GET /story_ships.json
  def index
    @story_ships = StoryShip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @story_ships }
    end
  end

  # GET /story_ships/1
  # GET /story_ships/1.json
  def show
    @story_ship = StoryShip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story_ship }
    end
  end

  # GET /story_ships/new
  # GET /story_ships/new.json
  def new
    @story_ship = StoryShip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story_ship }
    end
  end

  # GET /story_ships/1/edit
  def edit
    @story_ship = StoryShip.find(params[:id])
  end

  # POST /story_ships
  # POST /story_ships.json
  def create
    @story_ship = StoryShip.new(params[:story_ship])

    respond_to do |format|
      if @story_ship.save
        format.html { redirect_to @story_ship, notice: 'Story ship was successfully created.' }
        format.json { render json: @story_ship, status: :created, location: @story_ship }
      else
        format.html { render action: "new" }
        format.json { render json: @story_ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /story_ships/1
  # PUT /story_ships/1.json
  def update
    @story_ship = StoryShip.find(params[:id])

    respond_to do |format|
      if @story_ship.update_attributes(params[:story_ship])
        format.html { redirect_to @story_ship, notice: 'Story ship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story_ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_ships/1
  # DELETE /story_ships/1.json
  def destroy
    @story_ship = StoryShip.find(params[:id])
    @story_ship.destroy

    respond_to do |format|
      format.html { redirect_to story_ships_url }
      format.json { head :no_content }
    end
  end
end
