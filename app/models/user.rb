class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fbid, :first_name, :last_name, :last_sign_in_at, :email_frequency, :deleted_at, :leave_reason

  has_many :follow
  has_many :suggest
  has_many :manage
  has_many :super_manage
  has_and_belongs_to_many :roles

  has_many :following, :through => :follow, :source => :artist
  has_many :managing, :through => :manage, :source => :artist
  has_many :suggested_all, :through => :suggest, :source => :artist
  has_many :labels, :through => :super_manage
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = self.find_by_email(data.email)
    user
    else # Create a user with a stub password.
      user = self.create!(:email => data.email, :password => Devise.friendly_token[0,20], :fbid => data.id, :first_name => data.first_name, :last_name => data.last_name)
      UserMailer.welcome_email(user).deliver
    end
    Scraper.importFbLikes(access_token.credentials.token, user.id)
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
  def soft_delete
    # assuming you have deleted_at column added already
    update_attribute(:deleted_at, Time.current)
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def friends_with? user, friends
    if friends.include? user.fbid
    true
    else
    false
    end
  end

  def manager?
    if managing.count > 0
    true
    else
    false
    end
  end

  def manage_artist artist_id
    t = manage.create(:artist_id => artist_id)
    t.save
    return t.id
  end

  def unmanage_artist artist_id
    manage.delete(manage.where(:user_id => self.id, :artist_id => artist_id))
  end

  def follow_artist artist_id
    t = follow.create(:artist_id => artist_id)
    return t.id
  end

  def unfollow_artist artist_id
    follow.delete(follow.where(:user_id => self.id, :artist_id => artist_id))
  end

  def suggest_artist artist_id
    t = suggest.create(:artist_id => artist_id)
    return t.id
  end

  def unsuggest_artist(artist_id)
    suggest.where(:artist_id => artist_id).each do |f|
      f.ignore = true
      f.save
    end
  end

  def following?(artist_id)
    if !Follow.where(:artist_id => artist_id, :user_id => id).empty?
    true
    else
    false
    end
  end

  def managing?(artist_id)
    if !Manage.where(:artist_id => artist_id, :user_id => id).empty?
    true
    else
    false
    end
  end

  def suggested
    suggested_all.where("suggests.ignore = ?",false)
  end

  def suggested?(artist_id)
    if !Suggest.where(:artist_id => artist_id, :user_id => id).empty?
    true
    else
    false
    end
  end

end
