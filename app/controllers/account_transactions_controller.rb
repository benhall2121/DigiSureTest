class AccountTransactionsController < ApplicationController
  def index
    @account_transactions = AccountTransaction.all
  end

  def new
    @account_transaction = AccountTransaction.new
    @bank_account = params[:bank_account].nil? ? current_user.bank_accounts.first : BankAccount.find(params[:bank_account])
  end

  def create
  	account_transaction_params[:transfer_to_id] = "" if account_transaction_params[:transaction_type].downcase != "transfer"
    @account_transaction = AccountTransaction.new(account_transaction_params)
    
    @bank_account = account_transaction_params[:bank_account_id].nil? ? current_user.bank_accounts.first : BankAccount.find(account_transaction_params[:bank_account_id])

    respond_to do |format|
      if @account_transaction.save
        if ['withdrawal', 'transfer'].include? @account_transaction.transaction_type.downcase
          @account_transaction.bank_account.update!(balance: @account_transaction.bank_account.balance - @account_transaction.amount)
          @account_transaction.transfer_to_bank_account.update!(balance: @account_transaction.transfer_to_bank_account.balance + @account_transaction.amount) if @account_transaction.transaction_type.downcase == 'transfer'
        elsif @account_transaction.transaction_type.downcase == 'deposit'
          @account_transaction.bank_account.update!(balance: @account_transaction.bank_account.balance + @account_transaction.amount)
        end

        format.html { redirect_to user_path(current_user), notice: 'Transaction was successfully saved.' }
        format.json { render :show, status: :created, location: @account_transaction }
      else
        format.html { render :new }
        format.json { render json: @account_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def account_transaction_params
      params.require(:account_transaction).permit!
    end
end