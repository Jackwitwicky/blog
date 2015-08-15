class SessionsController < ApplicationController
  def new
    session[:previous_article_page] = request.env['HTTP_REFERER']
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      #login the user
      log_in user
      flash[:success] = "You have successfully been logged in."

      if admin_logged_in?
        redirect_to admins_index_path
      elsif session[:previous_article_page]
        redirect_to session[:previous_article_page]
      else
        redirect_to articles_path
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
