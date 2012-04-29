class StoryrelationsController < ApplicationController
  # GET /storyrelations
  # GET /storyrelations.json
  def index
    @storyrelations = Storyrelation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @storyrelations }
    end
  end

  # GET /storyrelations/1
  # GET /storyrelations/1.json
  def show
    @storyrelation = Storyrelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @storyrelation }
    end
  end

  # GET /storyrelations/new
  # GET /storyrelations/new.json
  def new
    @storyrelation = Storyrelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @storyrelation }
    end
  end

  # GET /storyrelations/1/edit
  def edit
    @storyrelation = Storyrelation.find(params[:id])
  end

  # POST /storyrelations
  # POST /storyrelations.json
  def create
    @storyrelation = Storyrelation.new(params[:storyrelation])

    respond_to do |format|
      if @storyrelation.save
        format.html { redirect_to @storyrelation, notice: 'Storyrelation was successfully created.' }
        format.json { render json: @storyrelation, status: :created, location: @storyrelation }
      else
        format.html { render action: "new" }
        format.json { render json: @storyrelation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /storyrelations/1
  # PUT /storyrelations/1.json
  def update
    @storyrelation = Storyrelation.find(params[:id])

    respond_to do |format|
      if @storyrelation.update_attributes(params[:storyrelation])
        format.html { redirect_to @storyrelation, notice: 'Storyrelation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @storyrelation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storyrelations/1
  # DELETE /storyrelations/1.json
  def destroy
    @storyrelation = Storyrelation.find(params[:id])
    @storyrelation.destroy

    respond_to do |format|
      format.html { redirect_to storyrelations_url }
      format.json { head :no_content }
    end
  end
end
