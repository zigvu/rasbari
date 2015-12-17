require_dependency "admin/application_controller"

module Admin
  class UsersController < ApplicationController
    authorize_actions_for ::User
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    # GET /users
    def index
      @users = ::User.all
    end

    # GET /users/1
    def show
    end

    # GET /users/new
    def new
      @user = ::User.new
      @rolesHash = Admin::UserRoles.new(nil).to_h
    end

    # GET /users/1/edit
    def edit
      @rolesHash = Admin::UserRoles.new(nil).to_h
    end

    # POST /users
    def create
      prm = user_params
      prm.merge!({"password" => "abcdefgh", "password_confirmation" => "abcdefgh"})

      @user = ::User.new(prm)
      if @user.save
        redirect_to @user, notice: 'User was successfully created. Please change default password immediately.'
      else
        render :new
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = ::User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :srole)
      end
  end
end
