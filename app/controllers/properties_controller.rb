class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show edit destroy]

  def index
    @properties = Property.all
    # The `geocoded` scope filters only properties with coordinates
    @markers = @properties.geocoded.map do |property|
      {
        lat: property.latitude,
        lng: property.longitude,
        info_window_html: "<h1>Hello</h1>"
        # render_to_string(partial: "info_window", locals: {flat: flat})
        # info_window: render_to_string(partial: "info_window", locals: {property: property})
      }
    end
  end

  def show
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user
    @team = Team.new
    @team.property = @property
    @team.user = current_user
    @team.profession = 'Manager'
    @property.teams << @team
    if @property.save
      redirect_to properties_path, notice: 'Property was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @property = Property.find(params[:id])
    if @property.update(property_params)
      redirect_to properties_path, notice: 'Property was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path, notice: 'Property was successfully destroyed.'
  end

  private

  def property_params
    params.require(:property).permit(:title, :address, :description,
                                     :default_job_price, :default_cleaning_from,
                                     :default_cleaning_until)
  end
  def set_property
    @property = Property.find(params[:id])
  end
end
