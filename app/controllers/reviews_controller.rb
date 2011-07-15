class ReviewsController < ApplicationController
  before_filter :load_review
  
   def index
    @reviews = Review.all
    respond_to do |format|
      format.html #we only respond to the html request
    end
  end
  
  def new
    @review = Review.new
    if !request.xhr?
      @reviews = Review.all
    end

    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def create
    @review = Review.create(params[:review])
    respond_to do |format|
      format.html { redirect_to reviews_path() }
      format.js {render :layout => false}
    end
  end

  #This is not a "normal" update, I'll use this one to add points to the review
  def update
    @review = Review.find(params[:id])
    @review.score = @review.score + 1
    @review.save

    respond_to do |format|
      format.html { redirect_to reviews_path }
      format.js {render :layout => false}
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_path }
      format.js {render :layout => false}
    end
  end
  
  protected

  def load_review
   @review = "This is a factice post, I hope you like it. Just review on the bottom!"
  end
end
