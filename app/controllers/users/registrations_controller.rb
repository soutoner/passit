class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource/update/profile
  def update_profile
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_profile_resource(resource, update_profile_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # PUT /resource/update/password
  def update_password
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_password_resource(resource, update_password_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # DELETE /resource/avatar
  def destroy_avatar
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource.avatar.destroy
    resource.save
    flash[:success] = 'Avatar successfully deleted.'
    redirect_to after_update_path_for(resource)
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :surname, :username, :email, :password, :password_confirmation) }
    end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      user_path(resource)
    end

    # The path used after sign up.
    def after_update_path_for(resource)
      edit_user_registration_path
    end

    def update_profile_params
      params.require(:user).permit(:name, :surname, :avatar, :destroy_avatar)
    end

    def update_password_params
      params.require(:user).permit(:password, :password_confirmation, :current_password)
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    def update_profile_resource(resource, params)
      resource.update_without_password(params)
    end

    def update_password_resource(resource, params)
      resource.update_with_password(params)
    end
end
