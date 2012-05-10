class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json
  def index
    @artists = Artist.search(params[:search])
    if(params[:search] == nil)
      @artists = Artist.page params[:page]
    elsif @artists.empty?
      @search = params[:search]
      return render "no_results"
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @artists }
      end
    end
  end

  def no_results
    respond_to do |format|
      format.html
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])
    @itunes = ItunesSearch::Base.new
    @itunes_artist_url = @itunes.search("term"=>@artist.name, "country" => "gb").results.first.artistViewUrl
    @amazon_artist = Amazon::Ecs.item_search(@artist.name, :search_index => 'Music')
    @user = current_user
    @timeline = Timeline.artist(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
    end
  end

  # GET /artists/new
  # GET /artists/new.json
  def new
    @artist = Artist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @artist }
    end
  end

  # GET /artists/1/edit
  def edit
    @artist = Artist.find(params[:id])
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(params[:artist])

    respond_to do |format|
      if @artist.save
        format.html { redirect_to @artist, :notice => 'Artist was successfully created.' }
        format.json { render :json => @artist, :status => :created, :location => @artist }
      else
        format.html { render :action => "new" }
        format.json { render :json => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /artists/1
  # PUT /artists/1.json
  def update
    @artist = Artist.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes(params[:artist])
        format.html { redirect_to @artist, :notice => 'Artist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @artist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url }
      format.json { head :no_content }
    end
  end
end
