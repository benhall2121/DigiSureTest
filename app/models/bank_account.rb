class BankAccount < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :account_number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: true

  has_many :account_transactions, class_name: "AccountTransaction", foreign_key: "bank_account_id", dependent: :destroy
  has_many :transfer_to_transactions, class_name: "AccountTransaction", foreign_key: "transfer_to_id", dependent: :destroy

  def all_transactions
    AccountTransaction.where("bank_account_id = ? OR transfer_to_id = ?", self.id, self.id)
  end

  def user_and_account
    "#{self.user.full_name} - #{self.account_number}"
  end

  def to_s
    account_number
  end
end
