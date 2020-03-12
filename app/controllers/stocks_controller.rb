
require 'json'
class StocksController < ApplicationController

def getStock
token = ENV['api_key']
link = 'https://api.worldtradingdata.com/api/v1/stock?&api_token='+token+'&symbol='+ stock_params[:ticker]
@stockAPI=RestClient.get(link)


render json: @stockAPI
end

def portfolio
@transactionSymbols = User.find(params[:id]).transactions.all.map{ |obj| obj['ticker']}.uniq.join(",") 
token = ENV['api_key']
link = 'https://api.worldtradingdata.com/api/v1/stock?&api_token='+token+'&symbol='+@transactionSymbols

@stockAPI = JSON.parse(RestClient.get(link))
@transactionsPrice = []

User.find(params[:id]).transactions.select("ticker, sum(qty) as shares").group("ticker").each{ |obj| 

    @stockAPI['data'].each{ |stockObj| 
    if stockObj['symbol']===obj['ticker'] 
        
        @transactionsPrice.push({'ticker': obj['ticker'], 'shares': obj['shares'] ,'price': stockObj['price'].to_f * obj['shares']})
    end
    }
}

render json: @transactionsPrice
end
private

def stock_params
   params.permit(:ticker)
end
def portfolio_params
   params.permit(:id)
end
end