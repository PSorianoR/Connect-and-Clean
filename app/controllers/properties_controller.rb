class PropertiesController < ApplicationController
  before_action :set_property, only: %i[info show edit destroy]

  def index
    @properties = current_user.properties
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

    @cleaners = @property.teams.where(profession: "cleaner").map(&:user)

    # Response when html is requested, used for the map on properties show.
    respond_to do |format|
      format.html {
        @markers = [{
            lat: @property.latitude,
            lng: @property.longitude,
            info_window_html: render_to_string(partial: "info_window", locals: {property: @property})
          }]
      }
    end
  end

  def info
    @cleaners = @property.teams.where(profession: "cleaner").map(&:user)

    # JSON response to stimulus controller job_form_controller.js
    respond_to do |format|
      format.json { render json: { property: @property, cleaners: @cleaners } } # Respond with JSON data
    end

  end

  def new
    @property = Property.new
    @team = Team.new
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user

    array_of_managers = params[:property][:teams][:manager_id].compact_blank
    array_of_cleaners = params[:property][:teams][:cleaner_id].compact_blank

    create_teams(@property, array_of_managers, 'manager')
    create_teams(@property, array_of_cleaners, 'cleaner')

    @team = Team.new
    user_to_manager(@team, @property)

    if @property.save
      redirect_to properties_path, notice: 'Property was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
    # Easy to read right? This clean code is being offered by Pedro! Try to do the same!
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
      :default_cleaning_until, :team, :photo)

  end

  def set_property
    @property = Property.find(params[:id])
  end

  def user_to_manager(team, property)
    property.teams << Team.new(user_id: current_user.id, profession: 'manager')
  end

  def create_teams(property, user_ids, profession)
    user_ids.each do |user_id|
      property.teams << Team.new(user_id: user_id, profession: profession)
    end
  end
end
