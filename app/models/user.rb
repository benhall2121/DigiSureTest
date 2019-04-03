class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :bank_accounts, dependent: :destroy

  def full_name
    "#{first_name.blank? && last_name.blank? ? email : (first_name + ' ' + last_name)}"
  end

  def total_balance
    self.bank_accounts.map(&:balance).inject(0, &:+)
  end
end
