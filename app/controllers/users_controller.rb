class UsersController < ApplicationController
  def index
    @users = User.all
    @balance = current_user.balance
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "user was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :cpf)
    end
end
