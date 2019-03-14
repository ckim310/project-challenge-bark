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
    # keep track of 0 likes in the last hour to append to end of all dogs_sorted array
    @no_likes = []
    # keep track of dogs with the most likes
    @max_likes= []
    
    i = 0
    while i < @dog_likes.length
      if @dog_likes.length == 1
        @dogs_sorted.push(@all_dogs[i])
        break
      end
      
      if @dog_likes[i] == 0
        @no_likes.push(@all_dogs[i])
      else
        j = i + 1
        current_most_likes = @dog_likes.max
        while j < @dog_likes.length
          if @dog_likes[i] > @dog_likes[j]
            if @dog_likes[i] == current_most_likes
              @max_likes.unshift(@all_dogs[i])
            else
              @dogs_sorted.unshift(@all_dogs[i])
            end
            if @dog_likes[j] != 0
              @dogs_sorted.push(@all_dogs[j])  
            end 
          elsif @dog_likes[i] < @dog_likes[j]
            if @dog_likes[j] == current_most_likes
              @max_likes.unshift(@all_dogs[j])
            else
              @dogs_sorted.push(@all_dogs[j])
            end
            @dogs_sorted.push(@all_dogs[i])
          end

          j += 1
        end
      end

      i += 1
    end

    # add all arrays together to have array of dog objects in order of most likes in last hour
    @dogs_sorted = @max_likes + @dogs_sorted + @no_likes

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
    @dog = Dog.new(dog_params)
    
    if current_user
      @dog.owner_id= current_user.id
    end

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
