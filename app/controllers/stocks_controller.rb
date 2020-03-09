
class StocksController < ApplicationController

def getStock
token = ENV['api_key']
link = 'https://api.worldtradingdata.com/api/v1/stock?&api_token='+token+'&symbol='+ stock_params[:ticker]
@stockAPI=RestClient.get(link)

render json: @stockAPI
end

private

def stock_params
   params.permit(:ticker)
end

end