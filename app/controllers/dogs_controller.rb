class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    # add paginate to update index query to only pick up 5 dogs on each page
    # @dogs = Dog.paginate(:page => params[:page], :per_page => 5)
    

    @all_dogs = Dog.all

    @dog_likes = @all_dogs.map do |dog|
      current_time = DateTime.now
      hour_ago = DateTime.now - 1.hour
      likes = dog.likes.where('created_at BETWEEN ? AND ?', hour_ago, current_time).length || 0
    end

    @dogs_sorted = []
    i = 0
    
    while i < @dog_likes.length
      if @dog_likes.length == 1
        @dogs_sorted.push(@all_dogs[i])
        break
      end

      j = i + 1
      while j < @dog_likes.length
    
        if @dog_likes[i] > @dog_likes[j]
          @dogs_sorted.unshift(@all_dogs[i])
          if j == @dog_likes.length - 1
            @dogs_sorted.push(@all_dogs[j])
          end
      
          break
        elsif @dog_likes[i] < @dog_likes[j]
          if j == @dog_likes.length - 1
            @dogs_sorted.unshift(@all_dogs[j])
          end
          @dogs_sorted.push(@all_dogs[i])
      
          break
        end

        j += 1
      end

      i += 1
    end

    @dogs = Dog.order_as_specified(:id => @dogs_sorted.each{|dog| dog.id}).paginate(:page => params[:page], :per_page => 5)

  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @dog = Dog.find(params[:id])
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = current_user.dogs.new(dog_params)

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update

    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end
end
