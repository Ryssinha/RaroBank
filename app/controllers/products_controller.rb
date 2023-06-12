class ProductsController < ApplicationController
    def index
      @products = Product.all
    end
  
    def new
        @product = Product.new
    end
  
    def create
        @product = Product.new(product_params)
        @investment = Investment.new(investment_params.merge(user: current_user, product: @product))
        
        if @product.save && @investment.save
            redirect_to products_path, notice: 'Produto e investimento criados com sucesso.'
        else
            render :new, alert: 'Erro ao criar o produto e o investimento.'
        end
    end
  
    def show
      @product = Product.find(params[:id])
    end
  
    def edit
      @product = Product.find(params[:id])
    end
  
    def update
      @product = Product.find(params[:id])
      if @product.update(product_params)
        redirect_to product_path(@product), notice: 'Produto atualizado com sucesso.'
      else
        render :edit, alert: 'Erro ao atualizar o produto.'
      end
    end
  
    def destroy
      @product = Product.find(params[:id])
      @product.destroy
      redirect_to products_path, notice: 'Produto excluído com sucesso.'
    end
  
    private
  
    def product_params
      params.require(:product).permit(:name, :punctuation, :start_date, :end_of_term, :minimum_investment_amount, :image_url, :premium, :additional_fee, :fee_id)
    end
  end
  