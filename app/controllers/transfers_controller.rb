class TransfersController < ApplicationController
  before_action :authenticate_user!

  def new
    @transfer = Transfer.new
    @contacts = contacts
  end

  def create
    if within_transfer_hours?
      @transfer = Transfer.new(transfer_params)
      @transfer.sender = current_user
      receiver = find_receiver

      if receiver && !validate_receiver
        @transfer.receiver = receiver
        Transfer.transaction do
          @transfer.save!
        end
        TransfersMailer.token_notification(@transfer).deliver_now
        redirect_to transfer_path(@transfer), notice: "Transferência criada com sucesso."
      else
        @contacts = contacts
        message = validate_receiver ? "Foram inseridos destinatários distintos" : "Destinatário inválido."
        @transfer.errors.add(:base, message)
        render :new
      end
    else
      @contacts = contacts
      @transfer = Transfer.new(transfer_params)
      @transfer.sender = current_user
      @transfer.errors.add(:base, "Transferência não pode ser realizada neste momento. A próxima transferência estará disponível em #{next_transfer_hour}.")
      render :new
    end
  end

  def confirmation
    @transfer = Transfer.find_by(token: params[:token])

    if @transfer.present?
      @transfer.status = :confirmed
      @transfer.execute_transfer
      @transfer.save
      TransfersMailer.transfer_notification(@transfer).deliver_now
      @message = "Transferência confirmada com sucesso!"
    else
      @message = "Transferência não encontrada!"
    end
  end

  def within_transfer_hours?
    current_time = Time.now
    current_time.strftime("%H:%M") >= "08:00" && current_time.strftime("%H:%M") <= "23:00" && (1..5).include?(current_time.wday)
  end

  def next_transfer_hour
    current_time = Time.current
    next_transfer_time = Time.new(current_time.year, current_time.month, current_time.day, 8, 0, 0) + next_transfer_day.days
    next_transfer_time.strftime("%d/%m/%Y às %H:%M")
  end

  def next_transfer_day
    day = Time.current.wday
    if day == 5
      3
    elsif day == 6
      2
    else
      1
    end
  end

  def show
    @transfer = Transfer.find(params[:id])
  end

  private

  def transfer_params
    params.require(:transfer).permit(:amount)
  end

  def find_receiver
    if my_contact.present?
      User.find_by(cpf: my_contact)
    else new_contact.present?
      User.find_by(cpf: new_contact)
    end
  end

  def validate_receiver
   my_contact.present? && new_contact.present? && (my_contact != new_contact)
  end

  def my_contact
    params[:transfer][:my_contact_cpf]
  end

  def new_contact
    params[:transfer][:new_contact_cpf]
  end

  def contacts
    current_user.transferable_contacts
  end
end
