
require 'json'
class StocksController < ApplicationController

def getStock
token = ENV['api_key']
link = 'https://fcsapi.com/api-v2/stock/latest?&access_key='+token+'&symbol='+ stock_params[:ticker]
@stockAPI=RestClient.get(link)
render json: @stockAPI
end

def portfolio
@userTransactions=User.find(params[:id]).transactions
@transactionSymbols = @userTransactions.map{ |obj| obj['ticker']}.uniq.join(",") 
@transactionsPrice = []
if(@transactionSymbols.length > 0)
token = ENV['api_key']
link = 'https://fcsapi.com/api-v2/stock/latest?&access_key='+token+'&symbol='+@transactionSymbols

@stockAPI = JSON.parse(RestClient.get(link))

@stockAPI=@stockAPI['response'].select{|stock| stock['country']==='united-states' }

@grouped=@userTransactions.select("ticker, sum(qty) as shares").group("ticker")
if @grouped.length > 0
    @grouped.each{ |obj| 
    @stockAPI.each{ |stockObj| 
    if obj['ticker'] === stockObj['symbol'] 
        @stockPrice = stockObj['price'].to_f * obj['shares']
        @change = stockObj['chg']
        @transactionsPrice.push({'ticker': obj['ticker'], 'qty': obj['shares'] ,'price': @stockPrice.round(2), 'change': @change})
    end
    }
}
end
end
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