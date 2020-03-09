class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes  :trade, :ticker, :price
end

