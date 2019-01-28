class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def import_csv
    result_hash = {}
    if params[:csv_file].present?
      if Product.process_csv(params[:csv_file], params[:delimeter], params[:delete_records])
        #  if response is true then sends the success message to UI
        result_hash.merge!(success: 'Import Complete')
      else #  if response is false then sends the error message to UI
        result_hash.merge!(danger: 'One of the record in CSV is not correct. Please correct the CSV and try again Or select the appropriate delimeter.')
      end
    else #  if response is false then sends the error message to UI
      result_hash.merge!(danger: 'Please Select CSV File')
    end
    respond_to do |format|
      format.html {redirect_to root_url, result_hash}
    end
  end
end
