class ExtractsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @sent_transfers = @user.sent_transfers.includes(:receiver)
    @received_transfers = @user.received_transfers.includes(:sender)
  end
end
