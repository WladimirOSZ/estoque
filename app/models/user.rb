class User < ApplicationRecord

  has_many :bids

  enum role: { user: 0, admin: 1 }

  validates :name, presence: true, length: { minimum: 3 }
  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }
  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



  def is_admin?
    user_signed_in? && current_user.admin?
  end

  before_validation :set_admin_if_email_matches, :sanitize_cpf



  def formatted_cpf
    cpf_with_mask = self.cpf.dup
    cpf_with_mask.insert(3, '.').insert(7, '.').insert(11, '-')
    cpf_with_mask
  end

  private

  def set_admin_if_email_matches
    if self.email.ends_with?("@leilaodogalpao.com.br")
      self.role = "admin"
    end
  end

  def sanitize_cpf
    self.cpf = self.cpf.gsub(/[^0-9]/, '')
  end

end
