class ImportSaleCSV
  include CSVImporter

  model Sale

  column :email, as: [/e.?mail/i], required: true
  column :order_date, as: ["date", "order_date"], required: true
  column :amount, as:["amount", "price", "cost"], required: true

  when_invalid :skip
end