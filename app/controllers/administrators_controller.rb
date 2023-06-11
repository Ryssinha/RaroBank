class AdministratorsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @users = User.all
    @classrooms = Classroom.all

    render 'administrators/dashboard'
  end

  def index
    @users = User.all
    @classrooms = Classroom.all
    @balance = current_user.balance
  end

  def add_user_to_classroom
    @user = User.find(params[:user_id])
    @classroom = Classroom.find(params[:classroom_id])

    if @user && @classroom
      Administrator.create(user: @user, classroom: @classroom)
      redirect_to classroom_path(params[:classroom_id]), notice: "Usuário adicionado à turma com sucesso."
    else
      redirect_to administrators_path, alert: "Falha ao adicionar usuário à turma."
    end
  end

  def classroom_management
    @classrooms = Classroom.all
    @users = User.all
  end

  def deposit
    @user = User.find(params[:user_id])
    @balance = @user.balance
    amount = params[:amount].to_f

    if @balance && amount.positive?
      @balance.deposit(amount)

      Transfer.create(sender: current_user, receiver: @user, amount: amount)

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

        Transfer.create(sender: current_user, receiver: user, amount: amount)
      end
      redirect_to administrators_path, notice: "Saldo atualizado com sucesso para todos os usuários."
    else
      redirect_to administrators_path, alert: "Falha ao adicionar saldo. Certifique-se de fornecer um valor positivo."
    end
  end

  private

  def authenticate_administrator!
    unless current_user.administrator?
      flash[:alert] = "Acesso negado. Você não é um administrador."
      redirect_to root_path
    end
  end

end
