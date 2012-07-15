class FollowsController < ApplicationController

  load_and_authorize_resource


  def index
    redirect_to artist_path(:id => params[:artist_id])
  end

  def create
    current_user.follow_artist params[:artist_id]
    current_user.unsuggest_artist(params[:artist_id])
    
    @tracked_artist = Artist.find(params[:artist_id])

    # Generate suggestions based on this
    if @tracked_artist.sdid?
      suggestions = Scraper.similar_artists_7digital(@tracked_artist.sdid)
      suggestions.each do |suggestion|
        if !Artist.where(:sdid => suggestion.id).empty?
          current_user.suggest_artist(Artist.where(:sdid => suggestion.id).first.id)
        end
      end
    end


    @artist = current_user.suggested[5] rescue nil
    respond_to do |format|
      format.html { redirect_to artist_path(:id => params[:artist_id]) }
      format.json { render("artists/show.json") }
      format.js { render "artists/show", :format => :js }
    end

  end
  
  def destroy
    current_user.unfollow_artist params[:artist_id]
    @artist_id = params[:artist_id]
    respond_to do |format|
      format.html { redirect_to artist_path(:id => params[:artist_id]) }
      format.js { render 'untrk_response' }
      format.json { render :json => { :response => :success } }
    end
  end

end
