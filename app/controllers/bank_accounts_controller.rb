class BankAccountsController < ApplicationController
  
  def index
    @bank_accounts = BankAccount.all
  end

  def show
    @bank_account = BankAccount.find_by_id(params[:id])
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
  	@bank_account = BankAccount.new(bank_account_params)
    
    respond_to do |format|
      if @bank_account.save
        format.html { redirect_to user_path(current_user), notice: 'Bank Account was successfully saved.' }
        format.json { render :show, status: :created, location: @bank_account }
      else
        format.html { render :new }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def bank_account_params
      params.require(:bank_account).permit!
    end
  
end