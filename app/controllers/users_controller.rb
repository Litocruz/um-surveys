class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  respond_to :html, :js
  respond_to :json, only: [:destroy, :destroy_multiple]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
    respond_with(@users)
  end

  def new
    @user = User.new
  end
  def show
    @user = User.find(params[:id])
  end
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Perfil actualizado"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #sign_in @user
      flash[:success] = "Usuario creado satisfactoriamente!"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def destroy
    @user=User.find(params[:id])
     if @user.destroy
        flash[:success] = "Usuario eliminado."
      end
      respond_with(@user)
    
    #redirect_to users_url
  end

  def destroy_multiple
    @users=User.destroy_all(id: params[:users_ids])
    if @users == []
      flash[:error] = "No se seleccionaron usuarios"
    else
      flash[:success] = "Usuarios Eliminados"
    end
    respond_with do |format|
      format.html { redirect_to users_path }
      format.json { head :no_content }
    end
  end

  private
    def user_params
     params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

  #before action
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
