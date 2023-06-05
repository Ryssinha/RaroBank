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
      format.html { redirect_to root_path, alert: 'Você não tem permissão para visualizar esse saldo.' }
    end
  rescue ActiveRecord::RecordNotFound
    format.html { redirect_to root_path, alert: 'Saldo não encontrado.' }
  end

  def deposit
    @balance = Balance.find(params[:id])
    amount = params[:amount].to_f

    if @balance.user == current_user && amount.positive?
      @balance.deposit(amount)
      format.html { redirect_to @balance, notice: "Saldo atualizado com sucesso. Saldo atual: #{'%.2f' % @balance.current_balance}" }
    else
      format.html { redirect_to @balance, alert: 'Falha ao adicionar saldo. Certifique-se de fornecer um valor positivo.' }
    end
  rescue ActiveRecord::RecordNotFound
    format.html {  redirect_to root_path, alert: 'Saldo não encontrado.' }
  end

  def withdraw
    @balance = Balance.find(params[:id])
    amount = params[:amount].to_f

    if @balance.user == current_user && amount.positive? && amount <= @balance.current_balance
      @balance.withdraw(amount)
      format.html { redirect_to @balance, notice: "Saque realizado com sucesso. Saldo atual: #{'%.2f' % @balance.current_balance}" }
    elsif @balance.user == current_user && amount > @balance.current_balance
      format.html { redirect_to @balance, alert: 'Valor do saque excede o saldo atual.' }
    else
      format.html { redirect_to @balance, alert: 'Falha ao efetuar o saque. Certifique-se de fornecer um valor positivo e menor ou igual ao saldo atual.' }
    end
  rescue ActiveRecord::RecordNotFound
    format.html { redirect_to root_path, alert: 'Saldo não encontrado.' }
  end

  def current_balance
    @balance = current_user.balance
  end

  private

  def check_administrator
    unless current_user.administrator?
      format.html { redirect_to root_path, alert: 'Você não tem permissão para adicionar saldo.' }
    end
  end
end
