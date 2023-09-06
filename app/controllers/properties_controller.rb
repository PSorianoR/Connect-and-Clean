class PropertiesController < ApplicationController
  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(new_property_params)
    @property.user = current_user
    if @property.save
      redirect_to properties_path, notice: 'Property was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def new_property_params
    params.require(:property).permit(:title, :address, :description,
                                     :default_job_price, :default_cleaning_from,
                                     :default_cleaning_until)
  end
end
