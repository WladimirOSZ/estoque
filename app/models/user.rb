class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
  enum sex: { Masculino: 0, Feminino: 1, Outro: 2, ND: 3 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def is_admin?
    user_signed_in? && current_user.admin?
  end
end
