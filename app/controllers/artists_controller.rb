class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json

  if Rails.env.production?
    before_filter :authenticate_user!, :except => [:show]
  else
    before_filter :authenticate_user!, :except => [:show,:index,:no_results]
  end
  
  def index
    @search = params[:search]
    if params[:search].blank?
      @empty_search = true
    elsif(params[:search].length < 2)
      @short_search = true
    else
      @artists = Artist.real_only.search(params[:search]).order(:name).page(params[:page]).per(10)
      @ids = @artists.map{|a| a.fbid}
    end
    
    if !@artists or @artists.empty?
      respond_to do |format|
        format.html { render 'artists/no_results' }# index.html.erb
        #format.html { redirect_to no_results_artists_path(:search => params[:search])}# index.html.erb
        format.json { render :json => ActiveSupport::JSON.encode(["failure"]) }
        return
      end
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json
      end
    end
  end
  
  def search
    @artists = Artist.real_only.search(params[:search])
    if(params[:search].length < 2)
      flash.now[:message] = "Please enter at least 2 characters into the search box"
      @artists = [];
    elsif @artists.empty?
      respond_to do |format|
        format.html { redirect_to no_results_artists_path(:search => params[:search])}# index.html.erb
        format.json { render :json => "" }
      end
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json
      end
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])
    @user = current_user
    @timeline = Timeline.artist(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
      format.js do 
        @follow = current_user.follow .where(:artist_id => params[:id]).first
      end
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
    @@sevendigital_apikey = "7dufgm34849u"
    require 'open-uri'
    if @artist.sdid?
      @sd_info = Hash.from_xml open("http://api.7digital.com/1.2/artist/details?artistid=#{CGI.escape(@artist.sdid)}&oauth_consumer_key=#{@@sevendigital_apikey}&country=GB&imageSize=350")
    end
    if @artist.itunes_id?
      @itunes_info = ActiveSupport::JSON.decode( open("http://itunes.apple.com/lookup?id=#{@artist.itunes_id}&country=GB"))
    end    
    respond_to do |format|
      format.html
    end
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
        format.js
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
  
  # Used to import a single artist at a time
  def import
    @artist = ArtistSubJob.single_import(params[:access_token], params[:fb_id], current_user.id)
    respond_to do |format|
      format.js
    end
  end
  
  # For first time users waiting for some initial artists to follow.
  def first_suggestions
    @user = current_user
    @six = 'false'
    @six = 'true' unless @user.suggested.count < 6
    respond_to do |format|
      format.js
      format.json { render :json => @six }
    end
  end


  def scrape_confirm
    @artist = Artist.find(params[:artist_id])
    require 'open-uri'
    if params[:store] == '7digital'
      @sd_info = Scraper.artist_7digital_search params[:search]
    elsif params[:store] == 'itunes'
      @itunes_info = ActiveSupport::JSON.decode( open("http://itunes.apple.com/search?term=#{ CGI.escape(params[:search])}&country=GB&limit=10&entity=musicArtist"))['results']
    else
      return render :nothing => true
    end
    respond_to do |format| 
      format.js
    end
  end
  
end
