class HomeController < ApplicationController
  def index
    response = Faraday.get(BC_API_URL)
    data = JSON.parse(response.body)
    @selic = data.last['valor']  
  end
end
