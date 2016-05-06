json.array!(@sales) do |sale|
  json.extract! sale, :id, :email, :order_date, :amount
  json.url sale_url(sale, format: :json)
end
