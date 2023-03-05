class ExpensesController < ApplicationController
  def index
    @expense=Expense.new
    if !user_signed_in?
      redirect_to new_user_session_path
    end
    # byebug
    if @current_user!=nil
      @expenses=User.find(current_user.id).expenses
    end
  end
  def create
      # byebug
    cid=current_user.id
    expense=Expense.new(param_expense)
    expense.user_id=cid
    expense.save!
    redirect_to root_path

  end
  def edit
    @expense=Expense.find(params[:id])

  end
  def destroy
    @expense=Expense.find(params[:id])
    @expense.destroy
  end
  private
  def param_expense
    params.require(:expense).permit(:title,:price,:type_of_expenses,:date)
  end
end
