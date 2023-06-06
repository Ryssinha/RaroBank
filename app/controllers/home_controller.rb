class HomeController < ApplicationController
  def index
    response = Faraday.get(BC_API_URL)
    data = JSON.parse(response.body)
    @selic = data.last['valor']  
  end

  def upload_image
    image = params[:image]
    response = ImgbbService.upload_image(IMGBB_KEY, image)
    
    puts JSON.parse(response)
    data = JSON.parse(response)
  end  
end
