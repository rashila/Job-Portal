class PositionsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /positions
  # GET /positions.xml
 #  before_filter :authenticate_user!
  def index
    @company = Company.find(params[:company_id])
    @positions = @company.positions
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
    load_data
    @company = Company.find(params[:company_id])
    @city = Contactinfo.find(@company.contactinfos_id).city
    @position = Position.new
    @positionskillset = Positionskillset.new
    @positionagency = Positionagency.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/1/edit
  def edit
    load_data
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.xml
  def create
    load_data
    @position  = Position.new(params[:position])
    @company = Company.find(params[:position][:company_id]) if params[:position][:company_id]
    @city = Contactinfo.find(@company.contactinfos_id).city
    @positionskillset = Positionskillset.new(params[:positionskillset])
    #@positionagency = Positionagency.new(params[:positionagency])
  
    if @position.errors.length == 0
      @positionskillset.positions_id = @position.id
      @positionskillset.skillsets_id = @position.skillset_ids
      @positionskillset.save
      @position.positionskillsets_id = @positionskillset.id
      @position.status = 'Open'
      @position.city = @city
      @position.published_status = "0"
      @position.save 
      if params[:commit] == "SAVE"
        flash[:notice] = "Position #{@position.title} was created successfully."
        redirect_to(@position)
      elsif params[:commit] == "SAVEPUBLISH"
        flash[:notice] = "Position #{@position.title} was created successfully."
        redirect_to("/savepublish?id=#{@position.id}")
      end  
    else
      render :action => "new"
    end
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
   load_data
    @position = Position.find(params[:id])
     if params[:commit] == "UPDATE"
         @position.update_attributes(params[:position])
        flash[:notice] = "Position #{@position.title} was updated successfully."
        redirect_to(@position)
      elsif params[:commit] == "UPDATEPUBLISH"
         @position.update_attributes(params[:position])
        flash[:notice] = "Position #{@position.title} was updated successfully."
        redirect_to("/updatepublish?id=#{@position.id}")
      else
          render :action => "edit" 
      end
    
  end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])
    @positionskillset = Positionskillset.find(@position.positionskillsets_id)
   
    if @position.published_status == "2" || @position.published_status == "3" 
       @positionagency = Positionagency.find(@position.positionagencies_id)
      @positionagency.destroy
      @position.destroy
      @positionskillset.destroy
    else
      @position.destroy
      @positionskillset.destroy
    end
    respond_to do |format|
      format.html { redirect_to("/positions/#{params[:company_id]}/index") }
    end
  end

  
  def savepublish
   
    @position = Position.find(params[:id])
    @agencies = Agency.find(:all)
    @positionagency = Positionagency.new(params[:positionagency])
    @data = params[:publish_all]
    @data1 = params[:publish_agency]
    if (@data &&  @data1)
      @positionagency.positions_id = @position.id
      @positionagency.save
      @position.positionagencies_id = @positionagency.id
      @position.published_status = "3"
      @position.update_attributes(params[:position])
     
      @positionagency.agencies_id = @position.agency_ids
      @positionagency.update_attributes(params[:positionagency])
      redirect_to(@position)
      flash[:notice] = "Public to all and agencies"
    elsif @data
      @position.published_status = "1"
      @position.update_attributes(params[:position])
      redirect_to(@position)
      flash[:notice] = "Public to all"
    elsif @data1
      @positionagency.positions_id = @position.id
      @positionagency.save
      @position.positionagencies_id = @positionagency.id
      @position.published_status = "2"
      @position.update_attributes(params[:position])
      
      @positionagency.agencies_id = @position.agency_ids
      @positionagency.update_attributes(params[:positionagency])
      redirect_to(@position)
      flash[:notice] = "Public to agencies"
    end 
  end   
  
  def updatepublish
    @position = Position.find(params[:id])
    @agencies = Agency.all
    # #@positionagency = Position.find(@position.positionagencies_id)
    # @data = params[:publish_all]
    # @data1 = params[:publish_agency]
    # # if (@data &&  @data1)
      # # @positionagency.positions_id = @position.id
      # # @positionagency.save
      # # @position.positionagencies_id = @positionagency.id
      # # @position.published_status = "Both"
      # # @position.update_attributes(params[:position])
      # # flash[:notice] = "Public to all and agencies"
      # # @positionagency.agencies_id = @position.agency_ids
      # # @positionagency.update_attributes(params[:positionagency])
    # if @data
      # @position.published_status = "Public"
      # @position.update_attributes(params[:position])
      # flash[:notice] = "Public to all"
    # elsif @data1
      # position_agency = Position.find(@position.positionagencies_id)
      # @positionagency = Positionagency.find(params[:position_agency])
      # @positionagency.positions_id = @position.id
      # @positionagency.save
      # @position.positionagencies_id = @positionagency.id
      # @position.published_status = "Agency"
      # @position.update_attributes(params[:position])
      # flash[:notice] = "Public to agencies"
      # @positionagency.agencies_id = @position.agency_ids
      # @positionagency.update_attributes(params[:positionagency])
    # end 
  end
 
  private
  def load_data
    @skillsets = Skillset.all
    
  end

end
