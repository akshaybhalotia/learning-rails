class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
    if !(session[:counter].nil?)
      session[:counter] = 0
    end

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    product = Product.find(@line_item.product.id)
    cart = @line_item.cart
    cart.delete_product(product.id)
    @line_item.destroy
    respond_to do |format|
      if cart.line_items.count > 0
        format.html { redirect_to cart, notice: 'Item removed' }
        format.json { head :no_content }
      else
        format.html { redirect_to store_url, notice: 'Cart empty!' }
        format.json { head :no_content }
      end
      
    end
  end

  # PUT /line_items/1
  def remove
    set_line_item
    if @line_item.quantity > 1
      product = Product.find(@line_item.product.id)
      cart = @line_item.cart
      @line_item = cart.delete_product(product.id)
      @line_item.save!
      respond_to do |format|
        format.html { redirect_to cart, notice: 'Item deleted' }
        format.json { head :no_content }
      end
    else
      destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
end
