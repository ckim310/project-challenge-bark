class LikesController < ApplicationController
  def new
    @like = Like.new

    render 'dogs/likes/new'
  end

  def create
    @like = current_user.likes.new(dog_id: params[:dog_id])
    @dog = Dog.find(params[:dog_id])
     

    if current_user.likes.where(dog_id: params[:dog_id]).length == 0
      @like.save
      respond_to do |format|
        format.html { redirect_to @dog, notice: 'Like was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      end
    else
      respond_to do |format|
        format.html { redirect_to @dog, notice: 'Already liked this dog, cannot like more than once' }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like = current_user.likes.where(dog_id: params[:dog_id])[0]
    @dog = Dog.find(params[:dog_id])

    if @like
      @like.destroy
      respond_to do |format|
        format.html { redirect_to @dog, notice: 'Like was successfully unliked.' }
        format.json { render :show, status: :created, location: @dog }
      end
    end
  end

end