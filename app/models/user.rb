class User < ApplicationRecord
    # before_save{self.email = email.downcase}
    #email属性を直接書き換える
    before_save{email.downcase!}
    validates :name, presence: true, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
    # パスワード呼び出しメソッド
    has_secure_password
    validates :password, presence: true, length:{minimum: 6}
end
