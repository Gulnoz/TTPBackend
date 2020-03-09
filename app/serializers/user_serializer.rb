class UserSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes  :name, :email, :balance, :transactions
end
