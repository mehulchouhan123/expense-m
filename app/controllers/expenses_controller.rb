class ExpensesController < ApplicationController
  def index
    @expense=Expense.new
    if !user_signed_in?
      redirect_to new_user_session_path
    end
    # byebug
    if @current_user!=nil
      @expenses=User.find(current_user.id).expenses
      if params[:array]!=nil
        if params[:array].size==1
          @expenses=Expense.where("type_of_expenses=? AND date>=",params[:array][0],params[:date])
        elsif  params[:array].size==2
          @expenses=Expense.where("(type_of_expenses=? OR type_of_expenses=?)AND date>=?",params[:array][0], params[:array][1].params[:date])
        elsif params[:array].size==3
         @expenses=Expense.where("(type_of_expenses=? OR type_of_expenses=? OR  type_of_expenses=?) AND date=? ",params[:array][0],params[:array][1],params[:array][2],params[:date])
        end
      end

    end
  
  end

  def create
    # byebug
    @date=Date.today
    if params[:date]=="Last week"
      @date=Date.today.last_week
    elsif params[:date]=="Last month"
      @date=Date.today.last_month
    elsif params[:date]=="Last year"
      @date=Date.today.last_year
    end

    if params[:commit]=='Save'
      cid=current_user.id
      expense=Expense.new(param_expense)
      expense.user_id=cid
      expense.save!
      redirect_to root_path
    else
      @hash={"Education"=>0,"Clothes"=>"0","Food"=>"0"}
      a=Array.new
      @hash.each do |k,v|
        v=params[k]
        if v=="1"
          a.push(k)
        end
      end
      @expenses=1
      if a.size==1
        @expenses=Expense.where("type_of_expenses=?",a[0])
        puts @expenses
      end
      redirect_to root_path(array: a,date: @date)
 
    end
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
