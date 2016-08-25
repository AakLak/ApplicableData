class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /sales
  # GET /sales.json
  def index
    if current_user
      @sales = current_user.sales.paginate(page: params[:page], :per_page => 10)
      @test_pages = current_user.sales.paginate(:page => params[:page])

      if @sales.length > 1 
        @most_purchases = @sales.most_purchases
        @newest_purchase = @sales.orders.last.order_date
        @oldest_purchase = @sales.orders.first.order_date
        @spread = (@newest_purchase - @oldest_purchase).to_f
        @max_spent = @sales.max_spent
      end
    end
    # render stream: true
  end  

  def rfm_score
    if current_user
      @sales = current_user.sales
      if @sales.length > 1 
        @most_purchases = @sales.most_purchases
        @newest_purchase = @sales.orders.last.order_date
        @oldest_purchase = @sales.orders.first.order_date
        @spread = (@newest_purchase - @oldest_purchase).to_f
        @max_spent = @sales.max_spent
      end


      respond_to do |format|
        format.html
        format.csv {send_data @sales.to_csv}
      end

    end
    # render stream: true  
  end

  def lifecycle_grid
    if current_user
      @sales = current_user.sales
      @days_ago = email_date_days_ago(@sales.latest_order)

      @five_order_emails = LC_order_count_emails(@sales.order_count_hash, 5)
      @four_order_emails = LC_order_count_emails(@sales.order_count_hash, 4)
      @three_order_emails = LC_order_count_emails(@sales.order_count_hash, 3)
      @two_order_emails = LC_order_count_emails(@sales.order_count_hash, 2)
      @one_order_emails = LC_order_count_emails(@sales.order_count_hash, 1)

      @five_purchase_181_day = LC_days_ago(@five_order_emails, @days_ago,181, 999999)

      @five_purchase_121_day = LC_days_ago(@five_order_emails, @days_ago,121, 180)

      @five_purchase_91_day = LC_days_ago(@five_order_emails, @days_ago,91, 120)

      @five_purchase_61_day = LC_days_ago(@five_order_emails, @days_ago,61, 90)

      @five_purchase_31_day = LC_days_ago(@five_order_emails, @days_ago,31, 60)

      @five_purchase_0_day = LC_days_ago(@five_order_emails, @days_ago,0, 30)

      @four_purchase_181_day = LC_days_ago(@four_order_emails, @days_ago,181, 999999)

      @four_purchase_121_day = LC_days_ago(@four_order_emails, @days_ago,121, 180)

      @four_purchase_91_day = LC_days_ago(@four_order_emails, @days_ago,91, 120)

      @four_purchase_61_day = LC_days_ago(@four_order_emails, @days_ago,61, 90)

      @four_purchase_31_day = LC_days_ago(@four_order_emails, @days_ago,31, 60)

      @four_purchase_0_day = LC_days_ago(@four_order_emails, @days_ago,0, 30)

      @three_purchase_181_day = LC_days_ago(@three_order_emails, @days_ago,181, 999999)

      @three_purchase_121_day = LC_days_ago(@three_order_emails, @days_ago,121, 180)

      @three_purchase_91_day = LC_days_ago(@three_order_emails, @days_ago,91, 120)

      @three_purchase_61_day = LC_days_ago(@three_order_emails, @days_ago,61, 90)

      @three_purchase_31_day = LC_days_ago(@three_order_emails, @days_ago,31, 60)

      @three_purchase_0_day = LC_days_ago(@three_order_emails, @days_ago,0, 30)

      @two_purchase_181_day = LC_days_ago(@two_order_emails, @days_ago,181, 999999)

      @two_purchase_121_day = LC_days_ago(@two_order_emails, @days_ago,121, 180)

      @two_purchase_91_day = LC_days_ago(@two_order_emails, @days_ago,91, 120)

      @two_purchase_61_day = LC_days_ago(@two_order_emails, @days_ago,61, 90)

      @two_purchase_31_day = LC_days_ago(@two_order_emails, @days_ago,31, 60)

      @two_purchase_0_day = LC_days_ago(@two_order_emails, @days_ago,0, 30)

      @one_purchase_181_day = LC_days_ago(@one_order_emails, @days_ago,181, 999999)

      @one_purchase_121_day = LC_days_ago(@one_order_emails, @days_ago,121, 180)

      @one_purchase_91_day = LC_days_ago(@one_order_emails, @days_ago,91, 120)

      @one_purchase_61_day = LC_days_ago(@one_order_emails, @days_ago,61, 90)

      @one_purchase_31_day = LC_days_ago(@one_order_emails, @days_ago,31, 60)

      @one_purchase_0_day = LC_days_ago(@one_order_emails, @days_ago,0, 30)

      @best_emails = @five_purchase_61_day.merge(@five_purchase_31_day.merge(@five_purchase_0_day.merge(@four_purchase_61_day.merge(@four_purchase_31_day.merge(@four_purchase_0_day))))).keys

      @best_hash = Hash.new
      @best_emails.each do |email|
        @best_hash[email] = 'best'
      end

      @disengaged_best_emails = @five_purchase_181_day.merge(@five_purchase_121_day.merge(@five_purchase_91_day.merge(@four_purchase_181_day.merge(@four_purchase_121_day.merge(@four_purchase_91_day))))).keys

      @disengaged_best_hash = Hash.new
      @disengaged_best_emails.each do |email|
        @disengaged_best_hash[email] = 'disengaged_best'
      end

      @disengaged_light_emails = @three_purchase_181_day.merge(@three_purchase_121_day.merge(@three_purchase_91_day.merge(@two_purchase_181_day.merge(@two_purchase_121_day.merge(@two_purchase_91_day.merge(@one_purchase_181_day.merge(@one_purchase_121_day.merge(@one_purchase_91_day)))))))).keys

      @disengaged_light_hash = Hash.new
      @disengaged_light_emails.each do |email|
        @disengaged_light_hash[email] = 'disengaged_light'
      end

      @new_high_potential_emails = @three_purchase_61_day.merge(@three_purchase_31_day.merge(@three_purchase_0_day.merge(@two_purchase_61_day.merge(@two_purchase_31_day.merge(@two_purchase_0_day.merge(@one_purchase_61_day.merge(@one_purchase_31_day))))))).keys

      @new_high_potential_hash = Hash.new
      @new_high_potential_emails.each do |email|
        @new_high_potential_hash[email] = 'new_high_potential'
      end

      @new_emails = @one_purchase_0_day.keys

      @new_hash = Hash.new
      @new_emails.each do |email|
        @new_hash[email] = 'new'
      end

      email_rank_hash = @best_hash.merge(@disengaged_best_hash).merge(@disengaged_light_hash).merge(@new_high_potential_hash).merge(@new_hash)
      respond_to do |format|
        format.html
        format.csv{send_data hash_to_csv(email_rank_hash)}
      end
    end
  end

  def upload
    @user_id = current_user.id if current_user
  end

  def upload_ftp
    @user_id = current_user.id if current_user
  end
  
  # GET /sales/1
  # GET /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    # @sale = Sale.new
    if current_user
      @sale = current_user.sales.build
    end
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales
  # POST /sales.json
  def create
    if current_user
    #@sale = Sale.new(sale_params)
    @sale = current_user.sales.build(sale_params)
    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  else
    redirect_to root_path, notice: 'You must be logged in to do this'
  end
end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import_csv
    Sale.import(params[:file], current_user.id)
    redirect_to lifecycle_grid_sales, notice: "Sales Data Imported Successfully"
  end

  def import_csv_test
    user_id = params[:user_id]
    import = ImportSaleCSV.new(file: params[:file]) do
      after_build do |sale|
        sale.user_id = user_id
          #refactor
          skip! if sale.email == nil
          skip! if sale.order_date == nil
          skip! if sale.amount == nil
        end
      end
      import.run!
    # p "*" * 50
    # p import.report.create_skipped_rows[0].row_array
    # p "*" * 50
    redirect_to lifecycle_grid_sales_path, notice: import.report.message
  end

  def import_ftp
    user_id = params[:user_id]
    import = ImportSaleCSV.new(path: './public/uploads/gotcha.csv') do
      after_build do |sale|
        sale.user_id = user_id
          #refactor
          skip! if sale.email == nil
          skip! if sale.order_date == nil
          skip! if sale.amount == nil
        end
      end
      import.run!
      redirect_to lifecycle_grid_sales_path, notice: import.report.message

    ### Old barebones CSV upload ###
    # Sale.ftp_import(params[:domain], params[:directory], params[:ftp_user], params[:ftp_password], current_user.id)
    # Net::FTP.open(params[:domain], params[:ftp_user], params[:ftp_password]) do |ftp|
    #   ftp.passive = true
    #   files = ftp.list
    #   #ftp.chdir("/root_level/nested/")
    #   ftp.chdir(params[:directory])
    #   ftp.getbinaryfile("large_sample_data.csv", './public/uploads/gotcha.csv')
    # end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:email, :order_date, :amount)
    end

    def require_login
      authenticate_user!

      # flash.now[:alert] = 'You must be signed in to use this feature!'
    end

  end
