class Sale < ActiveRecord::Base
	belongs_to :user

	def self.import(file, user_id)
		CSV.foreach(file.path, headers:true) do |row|
			Sale.create! row.to_hash.merge(user_id: user_id)
		end
	end

	def self.ftp_import(file, user_id)
		@domain = "ftp.yohogold.com"
		@ftp_login = "aaklak"
		@ftp_password = "Jc5sJqTK"
	end

	# for download CSV page
	def self.to_csv
		CSV.generate(headers: true) do |csv|

		end
	end

	def self.most_purchases
		self.group(:email).count.values.max
	end

	def self.orders
		self.group(:email).order("order_date ASC")
	end

	def self.consolidated
		self.group(:email).order("order_date DESC")
	end

	def self.num_orders
		email_orders = self.group(:email).count.to_a
		orders_email = []
		email_orders.each do |elem|
			orders_email << elem.reverse
		end
		orders_email
	end

	def self.max_spent
		email_totals = self.group(:email).sum(:amount)
		email_totals.values.max
	end
end
