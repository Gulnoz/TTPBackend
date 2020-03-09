class TransactionsController < ApplicationController

before_action :transaction_params, only: [:create]

def index
   @transactions = Transaction.all
   render json: transactionsSerializer.new(@transactions)
end

def create 
   @transaction = Transaction.create!(transaction_params)
       render json: @transaction
end
private

def transaction_params
   params.permit(:trade, :ticker, :price, :user_id)
end

end