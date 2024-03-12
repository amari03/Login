class ConfirmationsController < ApplicationController
    before_action :redirect_if_authenticated, only: [:create, :new]
    def create
        @user = User.find_by(email: params[:user] [:email].downcase)

        if @user.present? && @user.unconfirmed?
            @user.send_confirmation_email!
            redirect_to root_path, notice: "Check your email for confirmation instructions."
        else
            redirect_to new_confirmation_path, alert: "We could not find a user with that email or that email has already been confirmed."
        end
    end

    def edit
        @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

        if @user.present?
            @user.confirm!
            login @user
            redirect_to root_path, notice: "Your email has been confirmed."
        else
            redirect_to new_confirmation_path, alert: "We could not find a user with that confirmation token."
        end
    end

    def new
        @user = User.new
    end
end