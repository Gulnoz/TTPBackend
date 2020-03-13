
require 'json'
class StocksController < ApplicationController

def getStock
token = ENV['api_key']
link = 'https://api.worldtradingdata.com/api/v1/stock?&api_token='+token+'&symbol='+ stock_params[:ticker]
@stockAPI=RestClient.get(link)


render json: @stockAPI
end

def portfolio
@userTransactions=User.find(params[:id]).transactions
@transactionSymbols = @userTransactions.map{ |obj| obj['ticker']}.uniq.join(",") 
token = ENV['api_key']
link = 'https://api.worldtradingdata.com/api/v1/stock?&api_token='+token+'&symbol='+@transactionSymbols

@stockAPI = JSON.parse(RestClient.get(link))
@transactionsPrice = []

@grouped=@userTransactions.select("ticker, sum(qty) as shares").group("ticker")

@grouped.each{ |obj| 

    @stockAPI['data'].each{ |stockObj| 
    if obj['ticker'] === stockObj['symbol']
        
        @transactionsPrice.push({'ticker': obj['ticker'], 'shares': obj['shares'] ,'price': stockObj['price'].to_f.round(2) * obj['shares']})
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