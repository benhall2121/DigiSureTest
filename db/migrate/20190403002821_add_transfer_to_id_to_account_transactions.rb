class AddTransferToIdToAccountTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :account_transactions, :transfer_to_id, :integer
  end
end
