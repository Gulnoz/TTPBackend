class User < ApplicationRecord
    has_many :stocks, dependent: :destroy
    has_many :transactions, dependent: :destroy
    has_secure_password
    validates :email, uniqueness: { case_sensitive: false }
end
