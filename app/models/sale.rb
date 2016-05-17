require 'csv'
class Sale < ActiveRecord::Base
	belongs_to :user

	def self.import(file, user_id)
		CSV.foreach(file.path, headers:true) do |row|
			Sale.create! row.to_hash.merge(user_id: user_id)
		end
	end

	def self.emails
		self.pluck('DISTINCT email')
	end

	def self.old_to_new
		self.order(:order_date)
	end

	def self.num_orders
		self.group(:email).count
	end

	def self.last_order
		self.group(:email).order(:order_date)
	end

end
