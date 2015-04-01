################################################################################
#Author: Chad Greene
#Date: 12-13-14
#Modifications: 
#Description: The Measurements controller is responsible for measurmemnt objects
#used in the construction of recipe_ingredients
################################################################################
class MeasurementsController < ApplicationController
  
    #Ensures that only admins can add ingredients
  before_action :admin_user
  
  ##############################################################################
  # Allows new measurement to database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def new
    @page_title = "New Measurement"
    @measurement = Measurement.new
    @btnText = "Add Measurement"
    @obj = @measurement
    render 'shared/form'
  end
  
  ##############################################################################
  # Saves new measurement to database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def create
    @measurement = Measurement.new(msr_params)
    @obj = @measurement
    if(@measurement.save)
      flash.alert = "Measurement added"
      redirect_to new_measurement_path
    else
      flash.now.alert = "Error adding measurement"
      render 'shared/form'
    end
  end
  
  ##############################################################################
  # Edits an measurement in the database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def edit
    @page_title = "Edit Measurement"
    @measurement = Measurement.find(params[:id])
    @btnText = "Update Measurement"
    @obj = @measurement
    render 'shared/form'
  end
  
  ##############################################################################
  # Updates an measurement in the database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def update
    @measurement = Measurement.find(params[:id])
    @obj = @measurement
    if(@measurement.update(msr_params))
      redirect_to @measurement
    else
      render 'shared/form'
    end
  end
  
  ##############################################################################
  # Builds a list of all measurements in database
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def index
    @page_title = "All Measurements"
    @measurements = Measurement.all
  end
  
  ##############################################################################
  # Deletes a measurement from the database.
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def destroy
    @measurement = Measurement.find(params[:id]).destroy
    redirect_to measurements_path
  end
  
  ##############################################################################
  # Shows a measurement from the database.
  #
  # Entry: :admin_user
  #
  #  Exit: none
  ##############################################################################
  def show
    @measurement = Measurement.find(params[:id])
    @page_title = "#{@measurement.name}"
  end
  
#PRIVATE########################################################################
private
  ############################################################################
  # Allows only permitted parameters to be submitted and used on the pages
  ############################################################################  
  def msr_params
    params.require(:measurement).permit(:name, :abbr)
  end
end
