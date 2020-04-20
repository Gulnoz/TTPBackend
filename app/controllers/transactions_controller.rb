class TransactionsController < ApplicationController

before_action :transaction_params, only: [:create]

def index
   @transactions = Transaction.all
   render json: TransactionSerializer.new(@transactions)
end

def create 
#    token = ENV['api_key']
#    link = 'https://fcsapi.com/api-v2/stock/latest?&access_key='+token+'&symbol='+ params[:ticker]
#   @stockAPI = JSON.parse(RestClient.get(link))
#    @portfolioTransaction=[]
#   if @stockAPI.length>0

#   @stockPrice = @stockAPI['response'][0]['price']
  @user = User.find(transaction_params[:user_id]) 
  @newBalance = @user.balance - transaction_params[:price].to_i

   if @newBalance > 0
   
      @transaction = Transaction.create!(price: transaction_params[:price], 'qty': transaction_params[:qty], ticker: transaction_params[:ticker], user_id: transaction_params[:user_id])
  @user.update('balance': @newBalance)
   @stockPrice= @transaction['price'] * @transaction['qty']
   @portfolioTransaction={'id': @transaction.id,'ticker': @transaction['ticker'], 'qty': @transaction['qty'] ,'price': @stockPrice }
  
   render json: @portfolioTransaction

   else
      render json: { error: 'failed to create transaction'}, status: :not_acceptable

   end

end
private

def transaction_params
   params.permit(:ticker, :qty, :user_id, :price)
   # params.permit(:trade, :ticker, :price, :user_id)
end

end