class PasswordsController < ApplicationController
    before_action :redirect_if_authenticated

    def create
        @user = User.find_by(email: params[:user][:email].downcase)
        if @user.present?
            if @user.confirmed?
                @user.send_password_reset_email!
                redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
            else
                redirect_to root_path, alert: "Please conform your email first."
            end
        else
            redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
        end
    end

    def edit
        @user = User.find_signed(parmas[:password_reset_token], purpose: :reset_password)
        if @user.present? && @user.uncomfirmed?
            redirect_to new_confirmation_path, alert: "You must comfirm your email before you can sign in."
        elseif @user.nil?
        redirect_to new_password_path, alert: "Invalid or expired token."
        end
    end

    def new 
    end

    def update
        @user = User.find_signed(parmas[:password_reset_token], purpose: :reset_password)
        if @user
            if @user.unconfirmed?
                redirect_to new_confirmation_path, alert: "You must confirm your email before you can sign in."
            elseif @user.update(password_params)
            redirect_to login_path, notice: "Sign In."
            else
                flash.now[alert] = @user.error.full_messages.to_sentence
                render :new, status: :unprocessable_entity
            end
        else
            flash.now[:alert] = "Invalid or expired token."
            render :new, status: :unprocessable_entity
        end
        
    end

        private

        def password_params
            params.require(:user).permit(:password, :password_confirmation)
        end
    
end
