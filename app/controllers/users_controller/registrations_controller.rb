class UsersController::RegistrationsController < Devise::RegistrationsController
  before_filter :check_permissions, :only => [:timeline]
  skip_before_filter :require_no_authentication
 
  before_filter :featured_artists, :only => [:new]
  def check_permissions
    authorize! :create, resource
  end

  def destroy
    resource.soft_delete
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(resource)
  end

end
