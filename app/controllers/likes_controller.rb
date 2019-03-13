class LikesController < ApplicationController
  def create
    @like = current_user.likes.new(like_params)

    respond_to do |format|
      if @like.save

        format.html { redirect_to @dog, notice: 'Like was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
  def like_params
    params.require(:like).permit(:user_id, :dog_id)
  end

end