class PagesController < ApplicationController

  def home
    if(user_signed_in?)
      flash.keep
      return redirect_to '/tl'
    end
    # Used to auto log the user in.
    require 'koala'
    @graph = Koala::Facebook::API.new
    #flash[:success] = "<p>I done a success!</p>"
  end

  def manage

  end

  def recommended

  end
  
  def about
  
  end
  
  def privacy
  
  end
  
  def terms
  
  end
  
  def splash
    if(user_signed_in?)
      flash.keep
      return redirect_to '/timeline'
    end
    render :layout => 'splash'
  end 
  #def beta
  #  render :layout => 'beta'
  #end 
end
