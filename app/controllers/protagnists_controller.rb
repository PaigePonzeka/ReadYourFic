class ProtagnistsController < ApplicationController
  # GET /protagnists
  # GET /protagnists.json
  def index
    @protagnists = Protagnist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @protagnists }
    end
  end

  # GET /protagnists/1
  # GET /protagnists/1.json
  def show
    @protagnist = Protagnist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @protagnist }
    end
  end

  # GET /protagnists/new
  # GET /protagnists/new.json
  def new
    @protagnist = Protagnist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @protagnist }
    end
  end

  # GET /protagnists/1/edit
  def edit
    @protagnist = Protagnist.find(params[:id])
  end

  # POST /protagnists
  # POST /protagnists.json
  def create
    @protagnist = Protagnist.new(params[:protagnist])

    respond_to do |format|
      if @protagnist.save
        format.html { redirect_to @protagnist, notice: 'Protagnist was successfully created.' }
        format.json { render json: @protagnist, status: :created, location: @protagnist }
      else
        format.html { render action: "new" }
        format.json { render json: @protagnist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /protagnists/1
  # PUT /protagnists/1.json
  def update
    @protagnist = Protagnist.find(params[:id])

    respond_to do |format|
      if @protagnist.update_attributes(params[:protagnist])
        format.html { redirect_to @protagnist, notice: 'Protagnist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @protagnist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /protagnists/1
  # DELETE /protagnists/1.json
  def destroy
    @protagnist = Protagnist.find(params[:id])
    @protagnist.destroy

    respond_to do |format|
      format.html { redirect_to protagnists_url }
      format.json { head :no_content }
    end
  end
end
