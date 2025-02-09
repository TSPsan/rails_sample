class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :create_mysterious]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿しました。"
      redirect_to root_url
    else
      @feed_list = []
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_back(fallback_location: root_url)
  end

  # 怪文書を投稿する
  def create_mysterious
    @micropost = current_user.microposts.build(content: Micropost.generate_mysterious_document)
    if @micropost.save
      flash[:success] = "怪文書を投稿しました。"
      redirect_to root_url
    else
      @feed_list = []
      @feed_items = []
      render 'static_pages/home'
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
