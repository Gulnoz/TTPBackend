class TransactionsController < ApplicationController

before_action :transaction_params, only: [:create]

def index
   @transactions = Transaction.all
   render json: TransactionSerializer.new(@transactions)
end

def create 
   token = ENV['api_key']
   link = 'https://fcsapi.com/api-v2/stock/latest?&access_key='+token+'&symbol='+ params[:ticker]
  @stockAPI = JSON.parse(RestClient.get(link))
   if @stockAPI.length>0

  @stockPrice = @stockAPI['response'][0]['price']
   
   @transaction = Transaction.create!(price: @stockPrice, 'qty': transaction_params[:qty], ticker: transaction_params[:ticker], user_id: transaction_params[:user_id])
  
 
   @portfolioTransaction={'id': @transaction.id,'ticker': @transaction['ticker'], 'qty': @transaction['qty'] ,'price': @transaction['price'].to_f.round(2) * @transaction['qty']}
  
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