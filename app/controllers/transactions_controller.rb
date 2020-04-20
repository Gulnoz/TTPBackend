class TransactionsController < ApplicationController
before_action :transaction_params, only: [:create]

def index
   @transactions = Transaction.all
   render json: TransactionSerializer.new(@transactions)
end

def create 
   @user = User.find(transaction_params[:user_id]) 
   @newBalance = @user.balance - transaction_params[:price].to_i
  
   if @newBalance > 0
   
   @transaction = Transaction.create!(price: transaction_params[:price], 'qty': transaction_params[:qty], ticker: transaction_params[:ticker], user_id: transaction_params[:user_id])
   @user.update('balance': @newBalance)
   @stockPrice= @transaction['price'] * @transaction['qty']
   @change = transaction_params[:change]
   @portfolioTransaction={'id': @transaction.id,'ticker': @transaction['ticker'], 'qty': @transaction['qty'] ,'price': @stockPrice, 'change': @change}
   
   render json: @portfolioTransaction

   else
      render json: { error: 'failed to create transaction'}, status: :not_acceptable
   end

end

private
def transaction_params
   params.permit(:ticker, :qty, :user_id, :price, :change)
end

end