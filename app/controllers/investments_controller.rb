class InvestmentsController < ApplicationController
    def index
      @investment = Investment.all
    end
end