class User < ActiveRecord::Base
    has_many :favorites
    has_secure_password

    
    validates :username, :presence => true
    validates :username, :uniqueness => true
    validates :password, length: {minimum: 8}
    validates :password, format: {with: /\d/, message: "must include a number"}
end