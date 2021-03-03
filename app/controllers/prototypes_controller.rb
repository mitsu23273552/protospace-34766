class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] 
  before_action :set_prototype, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render new_prototype_path
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    unless @prototype.user_id == current_user.id
      redirect_to action: :index
    end
    @prototype = Prototype.find(params[:id])
  end

  def update
    prototype = Prototype.find(params[:id])
    prototype.update(prototype_params)
    if prototype.save
      redirect_to prototype_path(prototype.id)
    else
      @prototype = Prototype.find(params[:id])
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

end

private
def prototype_params
  params.require(:prototype).permit(:image, :title, :catch_copy, :concept).merge(user_id: current_user.id)
end

def set_prototype
  @prototype = Prototype.find(params[:id])
end

def move_to_index
  unless user_signed_in?
    redirect_to action: :index
  end
end