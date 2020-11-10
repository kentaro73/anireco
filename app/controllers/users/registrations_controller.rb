class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: :destroy
  
  def check_guest
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: "Guest user cannot be deleted."
    end
  end
end