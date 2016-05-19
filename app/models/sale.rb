require 'csv'
class Sale < ActiveRecord::Base
	belongs_to :user

	def self.import(file, user_id)
		CSV.foreach(file.path, headers:true) do |row|
			Sale.create! row.to_hash.merge(user_id: user_id)
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

	def self.emails
		self.pluck('DISTINCT email')
	end

	def self.old_to_new
		self.order(:order_date)
	end

	def self.num_orders
		email_orders = self.group(:email).count.to_a
		orders_email = []
		email_orders.each do |elem|
			orders_email << elem.reverse
		end
		orders_email
	end

end
