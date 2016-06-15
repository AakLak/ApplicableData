class Sale < ActiveRecord::Base
	belongs_to :user

	def self.import(file, user_id)
		CSV.foreach(file.path, headers:true) do |row|
			Sale.create! row.to_hash.merge(user_id: user_id)
		end
	end

	def self.ftp_import(domain, directory, user, pass, user_id)
		# @domain = "ftp.yohogold.com"
		# @ftp_login = "aaklak"
		# @ftp_password = "Jc5sJqTK"

		Net::FTP.open(domain, user, pass) do |ftp|
			files = ftp.list
			#ftp.chdir("/root_level/nested/")
			ftp.chdir(directory)
			ftp.passive = true
			ftp.getbinaryfile("large_sample_data.csv", './public/uploads/gotcha.csv')
			CSV.foreach('./public/uploads/gotcha.csv', headers:true) do |row|
				Sale.create! row.to_hash.merge(user_id: user_id)
			end

		end
	end

	#method for .csv download page
	def self.to_csv
		attributes = %w{email last_purchase num_orders total_spent r f m}
		most_purchases = all.most_purchases
		newest_purchase = all.orders.last.order_date
    oldest_purchase = all.orders.first.order_date
    spread = (newest_purchase - oldest_purchase).to_f
    max_spent = all.max_spent

		CSV.generate(headers: true) do |csv|
			csv << attributes

			all.consolidated.each do |customer|
				csv << [customer.email,
								customer.order_date,
								all.group(:email).count.values_at(customer.email).first.to_f,
								all.where(email: customer.email).sum(:amount).round(2),
								score(((customer.order_date - oldest_purchase).to_f/spread).round(2)),
							  score(all.group(:email).count.values_at(customer.email).first.to_f/ most_purchases),
								score((all.where(email: customer.email).sum(:amount)/max_spent).round(2))]
			end
		end
	end

	def self.unique_emails
		self.pluck(:email).uniq
	end

	# def self.email_orders
	# 	email_orders = self.pluck(:email, :order_date)
	# 	emails = []
	# 	email_orders.each do |email_order|
	# 		emails << email_order[0]
	# 	end
	# 	emails = emails.uniq!
	# 	order_list = []
	# 	emails.each do |email|
	# 		order_list << email
	# 		email_orders.each do |email_order|
	# 			order_list
	# 		end
	# 	end

	# end

	def self.tester
		sorted = self.order(:email, :order_date)
		unique_emails = sorted.pluck(:email).uniq
		days_between_order_arr = []
		unique_emails.each do |email|
			if sorted.where(email: email).count > 2
				first_order = sorted.where(email: email).first.order_date
				second_order = sorted.where(email: email).second.order_date
				days_between_order = second_order - first_order
				days_between_order_arr << days_between_order.to_f
			end
		end
		average_between_first_and_second = days_between_order_arr.sum/days_between_order_arr.size.to_f
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
