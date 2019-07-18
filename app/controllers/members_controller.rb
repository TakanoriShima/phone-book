class MembersController < ApplicationController
    def index
        if session[:flag] === 2
            flash[:success] = '新規登録に成功しました'
        elsif session[:flag] === 4
            flash[:success] = '更新に成功しました'
        elsif session[:flag] === 5
            flash[:success] = '削除に成功しました'
        end
        session[:flag] = nil
        @members = Member.all
    end
    def new
        @member = Member.new
        session[:flag] = 1
    end
    def create
        errors = []
        if member_params[:name] === ''
            errors << "名前を入力してください"
        end
        if member_params[:yomi] === ''
            errors << "読み仮名を入力してください"
        end
        if member_params[:phone] === ''
            errors << "電話番号を入力してください"
        elsif /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/ !~ member_params[:phone]
            errors << "電話番号は、xxx-xxxx-xxxx　で入力ください"
        end
        
        if errors.count === 0
            @member = Member.new(member_params)
            @member.save
            session[:flag] = 2
        end
        session[:error] = errors
        redirect_to root_path
    end
    def edit
        @member = find_by_id
        session[:flag] = 3
    end
    def update
        @member = find_by_id
        errors = []
        if member_params[:name] === ''
            errors << "名前を入力してください"
        end
        if member_params[:yomi] === ''
            errors << "読み仮名を入力してください"
        end
        if member_params[:phone] === ''
            errors << "電話番号を入力してください"
        elsif /^[0-9]{3}-[0-9]{4}-[0-9]{4}$/ !~ member_params[:phone]
            errors << "電話番号は、xxx-xxxx-xxxx　で入力ください"
        end
        
        if errors.count === 0
            @member.update(member_params)
            session[:flag] = 4
        end
        session[:error] = errors
        redirect_to root_path
    end
    def destroy
        #p 'ここ! destroy'
        @member = find_by_id
        @member.destroy
        session[:flag] = 5
        redirect_to root_path
    end
    private 
    def member_params
        params.require(:member).permit(:name, :yomi, :phone)
    end
    def find_by_id
        Member.find(params[:id])
    end
end
