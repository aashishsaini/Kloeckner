module ProductsHelper
  # get the table headers to display by fetching those from model attrs.
  def table_headers
    Product.column_names.reject{|s| s == 'id'|| s == 'created_at' || s == 'updated_at'}
  end
end
