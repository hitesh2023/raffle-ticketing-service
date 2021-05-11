class SessionsController < ApplicationController
  def login
    user = User
            .find_by(email: params[:user][:email])
            .try(:authenticate, params[:user][:password])

    if user
      session[:user_id] = user.id
      render json: { status: 200, user: user.as_json(only: [:id, :email]) }
    else 
      render json: { status: 401, error: :unauthorized  }
    end
  end

  def logout
    session.delete(:user_id)
    render json: { status: :success, logged_out: true  }
  end
end
   