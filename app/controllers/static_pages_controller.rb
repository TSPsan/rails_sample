class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_list = current_user.feed.search(params[:search])
      @feed_items = @feed_list.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
