class BalancesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_administrator, only: [:deposit]

  def show
    @balance = Balance.find(params[:id])
    if @balance.user == current_user
      @current_balance = @balance.current_balance
      @balance_deposited = @balance.balance_deposited
      @withdrawn = @balance.withdrawn
    else
      redirect_to root_path, alert: 'Você não tem permissão para visualizar esse saldo.'
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Saldo não encontrado.'
  end

  def deposit
    @balance = Balance.find(params[:id])
    amount = params[:amount].to_f

    if @balance.user == current_user && amount.positive?
      @balance.deposit(amount)

      @current_balance = @balance.current_balance
      @balance_deposited = @balance.balance_deposited
      @withdrawn = @balance.withdrawn

      redirect_to @balance, notice: "Saldo atualizado com sucesso. Saldo atual: #{'%.2f' % @current_balance}"
    else
      redirect_to @balance, alert: 'Falha ao adicionar saldo. Certifique-se de fornecer um valor positivo.'
    end
  end

  def withdraw
    @balance = Balance.find(params[:id])
    amount = params[:amount].to_f

    if @balance.user == current_user && amount.positive? && amount <= @balance.current_balance
      @balance.withdraw(amount)

      @current_balance = @balance.current_balance
      @balance_deposited = @balance.balance_deposited
      @withdrawn = @balance.withdrawn

      redirect_to @balance, notice: "Saque realizado com sucesso. Saldo atual: #{'%.2f' % @current_balance}"
    elsif @balance.user == current_user && amount > @balance.current_balance
      redirect_to @balance, alert: 'Valor do saque excede o saldo atual.'
    else
      redirect_to @balance, alert: 'Falha ao efetuar o saque. Certifique-se de fornecer um valor positivo e menor ou igual ao saldo atual.'
    end
  end

  def current_balance
    @balance = current_user.balance
  end

  private

  def authenticate_administrator!
    unless current_user.administrator?
      flash[:alert] = "Acesso negado. Você não é um administrador."
      redirect_to root_path
    end
  end

end
