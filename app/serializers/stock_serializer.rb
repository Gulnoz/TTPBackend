class StockSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes  :symbol, :price 
end