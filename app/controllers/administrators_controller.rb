class AdministratorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @classrooms = Classroom.all
    @balance = current_user.balance
  end

  def deposit
    @user = User.find(params[:user_id])
    @balance = @user.balance
    amount = params[:amount].to_f

    if @balance && amount.positive?
      @balance.deposit(amount)
      redirect_to administrators_path, notice: "Saldo atualizado com sucesso para o usuário."
    else
      redirect_to administrators_path, alert: "Falha ao adicionar saldo. Certifique-se de fornecer um valor positivo."
    end
  end

  def deposit_all
    amount = params[:amount].to_f

    if amount.positive?
      User.all.each do |user|
        balance = user.balance || Balance.new(user: user)
        balance.withdrawn ||= 0
        balance.balance_deposited ||= 0
        balance.current_balance ||= 0
        balance.save! unless balance.persisted?
        balance.deposit(amount)
      end
      redirect_to users_path, notice: "Saldo atualizado com sucesso para todos os usuários."
    else
      redirect_to users_path, alert: "Falha ao adicionar saldo. Certifique-se de fornecer um valor positivo."
    end
  end

  private

  def authenticate_user!
    unless current_user.administrator?
      redirect_to root_path, alert: "Você não tem permissão para adicionar saldo."
    end
  end
end
