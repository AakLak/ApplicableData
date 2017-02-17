class Sale < ActiveRecord::Base
  belongs_to :user

  def self.import(file, user_id)
    CSV.foreach(file.path, headers:true) do |row|
      if row["order_date"] != "order_date"
        row["order_date"] = Date.parse(row["order_date"]).to_s
        p row["order_date"]
        p "*" * 50
      end
      Sale.create! row.to_hash.merge(user_id: user_id)
    end
  end

  def self.ftp_import(domain, directory, user, pass, user_id)
    Net::FTP.open(domain, user, pass) do |ftp|
      ftp.passive = true
      #ftp.chdir("/root_level/nested/")
      ftp.chdir(directory)
      ftp.getbinaryfile("applicabledata.csv", './public/uploads/gotcha.csv')
      CSV.foreach('./public/uploads/gotcha.csv', headers:true) do |row|
        Sale.create! row.to_hash.merge(user_id: user_id)
      end
    end
  end

  def self.lifecycle_csv(hash)
    attributes = %w{email, rank}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      hash.each do |k, v|
        csv << [k, v]
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
  #   email_orders = self.pluck(:email, :order_date)
  #   emails = []
  #   email_orders.each do |email_order|
  #     emails << email_order[0]
  #   end
  #   emails = emails.uniq!
  #   order_list = []
  #   emails.each do |email|
  #     order_list << email
  #     email_orders.each do |email_order|
  #       order_list
  #     end
  #   end

  # end

  def self.days_between_order(older,newer)
    sorted = self.order(:email, :order_date)
    unique_emails = sorted.pluck(:email).uniq
    days_between_order_arr = []
    unique_emails.each do |email|
      if sorted.where(email: email).count > newer
        first_order = sorted.where(email: email)[older -1].order_date
        second_order = sorted.where(email: email)[newer -1].order_date
        days_between_order = second_order - first_order
        days_between_order_arr << days_between_order.to_f
      end
    end

    total_days_between = days_between_order_arr.sum
    total_days = days_between_order_arr.size
    average_days_between = (total_days_between/total_days) if (total_days > 0)
    return average_days_between.round(2) || 0
    # return total_days
  end

  def self.most_purchases
    self.group(:email).count.values.max
  end

  def self.orders
    self.select('sales.*').group(:email, :id).order("order_date ASC")
  end

  def self.consolidated
    self.select('sales.*').group(:email, :id).order("order_date DESC")
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

  def self.order_count_hash
    # result_hash = Hash.new(0)
    email_orders = self.group(:email).count
    # email_orders.each_value {|v| result_hash[v] += 1}
    # result_hash
  end

  def self.latest_order
    self.group(:email, :id).having('order_date = MAX(order_date)').pluck(:email, :order_date)
  end


end

def email_date_days_ago(array)
  result_hash = Hash.new
  array.each do |email_date|
    days_since = (email_date[1] - Date.today).to_f.abs
    email = email_date[0]
    result_hash[email] = days_since
  end
  result_hash
end

def LC_order_count_emails(email_orders_hash, num_orders)
  if num_orders == 5
    email_orders_hash.select{|k,v| v >= num_orders}.keys
  else
    email_orders_hash.select{|k,v| v == num_orders}.keys
  end
end

def LC_days_ago(email_array, email_days_hash, min_day, max_day)
  reduced_hash = Hash.new
  email_array.each do |email|
    if email_days_hash[email].between?(min_day, max_day)
      reduced_hash[email] = email_days_hash[email]
    end
  end
  reduced_hash
end

def slot_us(purchase_hash, days_hash, purchases, days_ago)
  emails_array = []
  enough_purchase_hash = purchase_hash.select{|k,v| v = purchases}
  enough_purchase_hash.each_key do |email|
    emails_array << email
  end
  result_hash = Hash.new
  emails_array.each do |email|
    result_hash[email] << days_hash.select{|k,v| k == email && v >= days_ago }
  end
  result_hash
end
