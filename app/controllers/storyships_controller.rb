class StoryshipsController < ApplicationController
  # GET /storyships
  # GET /storyships.json
  def index
    @storyships = Storyship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @storyships }
    end
  end

  # GET /storyships/1
  # GET /storyships/1.json
  def show
    @storyship = Storyship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @storyship }
    end
  end

  # GET /storyships/new
  # GET /storyships/new.json
  def new
    @storyship = Storyship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @storyship }
    end
  end

  # GET /storyships/1/edit
  def edit
    @storyship = Storyship.find(params[:id])
  end

  # POST /storyships
  # POST /storyships.json
  def create
    @storyship = Storyship.new(params[:storyship])

    respond_to do |format|
      if @storyship.save
        format.html { redirect_to @storyship, notice: 'Storyship was successfully created.' }
        format.json { render json: @storyship, status: :created, location: @storyship }
      else
        format.html { render action: "new" }
        format.json { render json: @storyship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /storyships/1
  # PUT /storyships/1.json
  def update
    @storyship = Storyship.find(params[:id])

    respond_to do |format|
      if @storyship.update_attributes(params[:storyship])
        format.html { redirect_to @storyship, notice: 'Storyship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @storyship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storyships/1
  # DELETE /storyships/1.json
  def destroy
    @storyship = Storyship.find(params[:id])
    @storyship.destroy

    respond_to do |format|
      format.html { redirect_to storyships_url }
      format.json { head :no_content }
    end
  end
end
