class TransactionsController < ApplicationController

before_action :transaction_params, only: [:create]

def index
   @transactions = Transaction.all
   render json: TransactionSerializer.new(@transactions)
end

def create 
   token = ENV['api_key']
   link = 'https://api.worldtradingdata.com/api/v1/stock?&api_token='+token+'&symbol='+ params[:ticker]
  @stockAPI = JSON.parse(RestClient.get(link))
   if @stockAPI.length>0

  @stockPrice=@stockAPI['data'][0]['price']
   
   @transaction = Transaction.create!(price: @stockPrice, 'qty': transaction_params[:qty], ticker: transaction_params[:ticker], user_id: transaction_params[:user_id])
  
  @portfolioTransaction={'ticker': @transaction['ticker'], 'shares': @transaction['qty'] ,'price': @transaction['price'].to_f.round(2) * @transaction['qty']}
  
   render json: @portfolioTransaction
   else
      render json: { error: 'failed to create transaction'}, status: :not_acceptable

   end

end
private

def transaction_params
   params.permit(:ticker, :qty, :user_id)
   # params.permit(:trade, :ticker, :price, :user_id)
end

end