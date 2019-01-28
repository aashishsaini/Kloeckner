require 'csv'
class Product < ApplicationRecord
  validates :part_number, presence: true

  # extract the CSV rows and its values
  # PART_NUMBER
  # BRANCH_ID
  # PART_PRICE
  # SHORT_DESC
  def self.extract_rows(path_to_csv)
    products = []
    csv_contents = CSV.read(path_to_csv.try(:tempfile) || path_to_csv)
    csv_contents.shift
    csv_contents.each do |row|
      products << row[0]
    end
    products
  end

  # process the csv
  def self.process_csv(path_to_csv, delimeter, delete_others)
    all_rows = self.extract_rows(path_to_csv)

    # pushing ids that needs to be saved
    updated_ids = []
    response = true

    # iterating all csv rows
    all_rows.each do |row|
      next if row.nil?
      content = row.split(delimeter)

      # if user selects the wrong delimeter
      if content.length == 1
        response = false
        next
      end

      product = where(part_number: content[0]).first
      if product # check if the product present in the system. if so then update the corresponding properties
        if update(product.id, branch_id: content[1], part_price: content[2], short_description: content[3])
          updated_ids.push(product.part_number)
        else #if unable to update the record. Then sends the result back
          response = false
        end
      else # check if the product is new then create a new entry in products table
        new_prod = new(part_number: content[0], branch_id: content[1], part_price: content[2], short_description: content[3])
        if new_prod.save
          updated_ids.push(new_prod.part_number)
        else #if unable to save the new record. Then sends the result back
          response = false
        end
      end
    end
    # check if the delete others check is checked then system should delete the other records
    # which are not a part of the CSV
    if delete_others == 'true'
      where('part_number not in (?)',updated_ids).delete_all
    end
    response
  end
end
