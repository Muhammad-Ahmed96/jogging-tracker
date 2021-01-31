class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :manager_user, only: :destroy

  # GET /users or /users.json
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1 or /users/1.json
  def show
    @jogtimes = @user.jogtimes.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        msg = "Account was succesfully created!"
        format.html { redirect_to @user }
        format.json { render json: {status: true, msg: msg, user_id: @user.id }}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: {status: false, errors: @user.errors.full_messages }}
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        msg = "Account was succesfully updated!"
        format.html { redirect_to @user }
        format.json { render json: {status: true, msg: msg }}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: {status: false, errors: @user.errors.full_messages }}
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:danger] = "Account was succesfully destroyed!"
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Check if a user is admin.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  # Check if a user is manager.
  def manager_user
    redirect_to(root_url) unless current_user.manager?
  end
  
end
