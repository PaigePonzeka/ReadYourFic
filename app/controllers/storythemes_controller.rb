class StorythemesController < ApplicationController
  # GET /storythemes
  # GET /storythemes.json
  def index
    @storythemes = Storytheme.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @storythemes }
    end
  end

  # GET /storythemes/1
  # GET /storythemes/1.json
  def show
    @storytheme = Storytheme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @storytheme }
    end
  end

  # GET /storythemes/new
  # GET /storythemes/new.json
  def new
    @storytheme = Storytheme.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @storytheme }
    end
  end

  # GET /storythemes/1/edit
  def edit
    @storytheme = Storytheme.find(params[:id])
  end

  # POST /storythemes
  # POST /storythemes.json
  def create
    @storytheme = Storytheme.new(params[:storytheme])

    respond_to do |format|
      if @storytheme.save
        format.html { redirect_to @storytheme, notice: 'Storytheme was successfully created.' }
        format.json { render json: @storytheme, status: :created, location: @storytheme }
      else
        format.html { render action: "new" }
        format.json { render json: @storytheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /storythemes/1
  # PUT /storythemes/1.json
  def update
    @storytheme = Storytheme.find(params[:id])

    respond_to do |format|
      if @storytheme.update_attributes(params[:storytheme])
        format.html { redirect_to @storytheme, notice: 'Storytheme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @storytheme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storythemes/1
  # DELETE /storythemes/1.json
  def destroy
    @storytheme = Storytheme.find(params[:id])
    @storytheme.destroy

    respond_to do |format|
      format.html { redirect_to storythemes_url }
      format.json { head :no_content }
    end
  end
end
