require 'csv'
class Sale < ActiveRecord::Base
	def self.import(file)
		CSV.foreach(file.path, headers:true) do |row|
			Sale.create! row.to_hash
		end
	end

	def emails
		self.pluck('DISTINCT email')
	end
end
