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
   # @company = Company.find(params[:id])
    
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
    puts params
    @position  = Position.new(params[:position])
    @company = Company.find(params[:position][:company_id]) if params[:position][:company_id]
    @city = Contactinfo.find(@company.contactinfos_id).city
   
    @positionskillset = Positionskillset.new(params[:positionskillset])
    @position.valid?
   
   respond_to do |format| 
     if params[:commit] == "SAVE"
     
       # @position.company_id = params[:company_id]
          if @position.errors.length == 0
             @positionskillset.positions_id = @position.id
             @positionskillset.skillsets_id = @position.skillset_ids
             @positionskillset.save
             @position.positionskillsets_id = @positionskillset.id
             @position.status = 'Open'
             @position.city = @city
             @position.save
          
         
            flash[:notice] = "Position #{@position.title} was created successfully."
         
            format.html { redirect_to(@position) }
            
         else
            format.html { render :action => "new" }
            format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
         end
      
    else if params[:commit] == "SAVE&PUBLISH"
           flash[:notice] = "Publish"
          format.html { redirect_to("/publish")}
        end
       
      end 
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
    load_data
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        
         flash[:notice] = "Position #{@position.title} was updated successfully."
        format.html { redirect_to(@position)}
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
    @positionskillset = Positionskillset.find(@position.positionskillsets_id)
    @position.destroy
    @positionskillset.destroy
    respond_to do |format|
      format.html { redirect_to("/positions/#{params[:company_id]}/index") }
      format.xml  { head :ok }
  end
end

  end
  
  def publish
     #@position = Position.find(params[:id])
     #flash[:notice] = "Position #{@position.title} was updated successfully."
     @data = params[:publish_all]
     @data1 = params[:publish_agency]
       if @data
         flash[:notice] = "Public to all"
       else if @data1
         flash[:notice] = "Public to agency"
         end
      end  
   end
   
  
  
  private
def load_data
    @skillsets = Skillset.all
end

end
