class PagesController < ApplicationController

  skip_before_filter :authenticate_user!
  caches_action :home, :layout => false
  caches_action :about, :layout => false
  caches_action :privacy, :layout => false
  caches_action :terms, :layout => false

  def home
    if (user_signed_in?)
      flash.keep
      # FIXME: This may be triggering the url shortener loop
      return redirect_to '/tl'
    end
    @releases = Rails.cache.fetch("homepage_releases", :expires_in => 24.hours) do
      Release.includes(:artist).all(:limit => 66, :condition => 'image_file_name IS NOT NULL')
    end
  end

  def about

  end

  def privacy

  end

  def terms

  end
end
