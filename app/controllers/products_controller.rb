class ProductsController < ApplicationController
	before_action :find_product, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new , :edit]
    before_action :check_admin , only:[:new , :update, :edit , :destroy, :create]

	def index	
       if params[:category].blank?
		@products = Product.all.order("created_at DESC")
		@order_item = current_order.order_items.new
       else
       	if params[:category] == 'All'
       	   @products = Product.all.order("created_at DESC")
       	   @order_item = current_order.order_items.new
         else
       	   @category_id = Category.find_by(name: params[:category]).id
           @products = Product.where(:category_id => @category_id).order("created_at DESC")
           @order_item = current_order.order_items.new
         end
       end
	end

	def show
		if @product.reviews.blank?
			@average_review = 0
		else
				@average_review = @product.reviews.average(:rating).round(2) 
			end
	end

	def new
    	@product = Product.new
		@categories = Category.all.map{|c| [c.name , c.id]}
	end

	def create
	  @product = Product.new(product_params)
		 @product.category_id = params[:category_id]
		if @product.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
	  @categories = Category.all.map{|c| [c.name , c.id]}
   end

	def update
	 @product.category_id = params[:category_id]
   	if @product.update(product_params)
			redirect_to product_path(@product)
		else
			render "edit"
		end
	end

	def destroy
		@product.destroy
		redirect_to root_path
	end


	private
	
	def product_params
		params.require(:product).permit(:title,:description,:price,:available,:discount,:image, :category_id)
	end

	def find_product
		@product = Product.find(params[:id])
	end
	
	


end
