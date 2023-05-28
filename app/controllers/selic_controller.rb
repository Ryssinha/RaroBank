class SelicController < ApplicationController
    def index
      response = Faraday.get(BC_API_URL)
      data = JSON.parse(response.body)
      @valor = data.last['valor']
  
      render json: @valor
    end
  end
  