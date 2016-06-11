class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]

  # GET /sales
  # GET /sales.json
  def index
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
    
  end

  def upload
    
  end
  
  # GET /sales/1
  # GET /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    # @sale = Sale.new
    @sale = current_user.sales.build
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales
  # POST /sales.json
  def create
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
    redirect_to sales_path, notice: "Sales Data Imported Successfully"
    p "*" * 50
    p params[:file]
    p params[:file].to_yaml
    p "*" * 50
  end

  def import_ftp
    Sale.ftp_import(params[:domain], params[:ftp_user], params[:ftp_password], current_user.id)
    redirect_to sales_path, notice: @ftp_login
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

  end
