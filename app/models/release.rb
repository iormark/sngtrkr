class Release < ActiveRecord::Base
  require 'open-uri'
  validates :name, :presence => true
  validates :date, :presence => true
  validates :artist_id, :presence => true

  has_attached_file :image, :styles => { 
      :release_i => ["310x311#"],
      :release_carousel => ["116x116#"],
      :activity_release => ["40x40#"],
      :original => ["500x500>"]
    }, 
    :convert_options => {
      :all => '-quality 40 -strip',
    },
    :fog_public => true

  has_many :tracks, :dependent => :delete_all
  has_many :notification, :dependent => :delete_all
  has_many :user_notifications, :through => :notification, :source => :user
  belongs_to :artist
  
  ajaxful_rateable :stars => 5, :allow_update => true, :dependent => :destroy
  
  after_create :notify_followers

  scope :unsaved_images, where('image_file_name is null and image_source is not null')

  before_save :default_values
  def default_values
    # Don't ignore new artists!
    self.ignore ||= false
    self.scraped ||= false
    self.image_attempts ||= 0
    true
  end

  # Notify users that follow this release's artist of this release.
  def notify_followers
    if self.date > (Date.today - 14)
      self.artist.followed_users.each do |user|
        user.release_notifications << self
      end  
    end
  end
  
  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  def itunes
    if itunes?
      return "http://clk.tradedoubler.com/click?p=23708&a=2098473&url=#{CGI.escape(super)}"
    else
      return nil
    end
  end

  def self.save_scraped_images
    Release.unsaved_images.each do |r|
      # Attempts to save an image with exponential backoff
      if !r.image_file_name and r.image_source
        if !r.image_last_attempt or (r.image_last_attempt + (2^r.image_attempts).hour) > Time.now
          puts "Would be saving" + r.image_source
          r.image_attempts = r.image_attempts ? r.image_attempts += 1 : 0
          r.image_last_attempt = Time.now

          io = open(r.image_source)
          if io
            def io.original_filename; base_uri.path.split('/').last; end
            io.original_filename.blank? ? nil : io      
            r.image = io
          end

          r.save
        end
      end
    end
  end

end
