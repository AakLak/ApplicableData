require 'csv'
class Sale < ActiveRecord::Base
	belongs_to :user
	def self.import(file, user_id)
		CSV.foreach(file.path, headers:true) do |row|
			Sale.create! row.to_hash.merge(user_id: user_id)
		end
	end

	def emails
		self.pluck('DISTINCT email')
	end
end
