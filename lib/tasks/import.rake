require 'csv'

namespace :import do
  desc "imports all data from csv"
  task seeds: :environment do

    data = { "Merchant" => ["db/csv/merchants.csv", Merchant],
          "Customer" => ["db/customers.csv", Customer],
          "Items" => ["db/items.csv", Item],
          "Invoice" => ["db/invoices.csv", Invoice],
          "Transactions" => ["db/transactions.csv", Transaction],
          "InvoiceItem" => ["db/invoice_items.csv", InvoiceItem]}

    data.each do |key, array|

      CSV.foreach(array[0], headers: true) do |row|
        array[1].create(row.to_h)
      end
      puts "There are #{array[1].count} #{key} in the database"
    end
  end

end
