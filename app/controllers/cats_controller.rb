class CatsController < ApplicationController
  before_action :redirect_if_incorrect_user, only: [:edit, :update]
  before_action :redirect_if_not_logged_in

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @cat_rental_requests = CatRentalRequest.where(cat_id: @cat.id)
    render :show
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to @cat
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to @cat
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    parameters = params.require(:cat).permit(:birth_date, :name, :color, :sex, :description)
    parameters[:user_id] = current_user.id
    parameters
  end

  def redirect_if_incorrect_user
    @cat = Cat.find(params[:id])
    redirect_to cats_url unless current_user.id = @cat.user_id
  end
end
