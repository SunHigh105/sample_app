module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
        # session[:user_id]が存在する場合は一時セッションからユーザーを取り出す
        if(user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        # それ以外の場合はcookies[:user_id]からユーザーを取り出す
        elsif(user_id = cookies.signed[:user_id])
            # raise       # テストがパスすれば、この部分がテストされていないことがわかる
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    def logged_in?
        !current_user.nil?
    end

    # 永続的セッションを破棄
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
    
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
end
