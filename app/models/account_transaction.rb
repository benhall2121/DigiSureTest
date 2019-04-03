class AccountTransaction < ApplicationRecord
  belongs_to :bank_account,    class_name: "BankAccount", foreign_key: "bank_account_id"
  belongs_to :transfer_to_bank_account, class_name: "BankAccount", foreign_key: "transfer_to_id", required: false


  TRANSACTION_TYPES = %w(Withdrawal Deposit Transfer)

  validates :bank_account, presence: true
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :transaction_number, presence: true, uniqueness: true

  before_validation :load_defaults

  def load_defaults
    if self.new_record?
      self.transaction_number = SecureRandom.uuid
    end
  end
end
