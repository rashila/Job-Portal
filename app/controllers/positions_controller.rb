class PositionsController < ApplicationController
  helper_method :sort_column, :sort_direction  
  # GET /positions
  # GET /positions.xml
 #  before_filter :authenticate_user!
  def index
    @positions = Position.find(:all)
    #@positions = Position.order(params[:sort] + ' ' + params[:direction])if (params[:sort] && params[:direction])


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.xml
  def show
    @position = Position.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/new
  # GET /positions/new.xml
  def new
    @position = Position.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.xml
  def create
    @position = Position.new(params[:position])
    puts "!!!!!!!"
    puts @position.inspect
    puts "@@@@@"
  #  @position.companies_id = @company.find(params[:id])
   # @position.save
    respond_to do |format|
      if @position.save
          puts "Sucess"
          flash[:notice] = "Position #{@position.title} was created successfully."
          format.html { redirect_to(@position) }
          #redirect_to("/positions/create", :notice => 'Position was created successfully')
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
     end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.html { redirect_to(@position, :notice => 'Position was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.html { redirect_to(positions_url) }
      format.xml  { head :ok }
  end
end
def search
    @page_title = "Search"
    @search =  Position.solr_search do |s|
        s.keywords params[:q]
      

   end

  end



end
