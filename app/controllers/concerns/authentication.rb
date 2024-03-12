module Authentication
    extend ActiveSupport::Concern

    included do
      before_action :current_user
      helper_method :current_user
      helper_method :user_signed_in?
    end

    def login(user)
        reset_session
        session[:current_user_id] = user.id
    end

    def forget(user)
        cookies.delete :remember_token
        user.generate_remember_token
    end

    def remember(user)
        user.generate_remember_token
        cookies.permanent.encrypted[:remember_token] = user.remember_token
    end

    def logout
        reset_session
    end

    def authenticate_user!
        redirect_to root_path, alert: "you need to login to access that page." unless user_signed_in?
    end

    def redirect_if_authenticated
        redirect_to root_path, alert: "You are logged in." if user_signed_in?
    end

    private

    def current_user
        Current.user ||= if session[:current_user_id].present?
            User.find_by(id: session[:current_user_id])
        elseif cookies.permanent.encrypted[:remember_token].present?
        end
    end

    def user_signed_in?
      Current.user.present?
    end
    
end