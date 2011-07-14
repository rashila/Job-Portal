class AgenciesController < ApplicationController
  # GET /agencies
  # GET /agencies.xml
  def welcome
    @agency = Agency.find(params[:id])
  end
  def index
    @agencies = Agency.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agencies }
    end
  end

  # GET /agencies/1
  # GET /agencies/1.xml
  def show
    @agency = Agency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # GET /agencies/new
  # GET /agencies/new.xml
  def new
    load_data
    @agency = Agency.new
    @contactinfo = Contactinfo.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agency }
    end
  end

  # GET /agencies/1/edit
  def edit
    load_data
    @agency = Agency.find(params[:id])
    @contactinfo= Contactinfo.find(@agency.contactinfos_id)
  end

  # POST /agencies
  # POST /agencies.xml
  def create
   load_data
    @agency = Agency.new(params[:agency])
    @contactinfo = Contactinfo.new(params[:contactinfo])
    @agency.valid?
    @contactinfo.valid?
    @agency.user_id = current_user.id

    respond_to do |format|
      if @agency.errors.length == 0 and @contactinfo.errors.length == 0
        @contactinfo.save(:validate => false)
        @agency.contactinfos_id = @contactinfo.id
        @agency.save(:validate => false)
        format.html { redirect_to(@agency) }
        flash[:notice] = "Agency #{@agency.name} was created successfully."
        format.xml  { render :xml => @agency, :status => :created, :location => @agency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agency.errors + @contactinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.xml
  def update
   load_data
    @agency = Agency.find(params[:id])
    @contactinfo = Contactinfo.find(@agency.contactinfos_id)
    if @contactinfo.update_attributes(params[:contactinfo])
    contactinfo_success = 1
    end
    if @agency.update_attributes(params[:agency])
    agency_success = 1
    end
    respond_to do |format|
     if contactinfo_success == 1 and agency_success == 1
        format.html { redirect_to("/agencies/"+@agency.id.to_s+"/welcome") }
        flash[:notice] = "Agency #{@agency.name} was successfully updated."
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agency.errors+@contactinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.xml
  def destroy
    @agency = Agency.find(params[:id])
    @contactinfo= Contactinfo.find(@agency.contactinfos_id)
    @agency.destroy
    @contactinfo.destroy

    respond_to do |format|
      format.html { redirect_to(agencies_url) }
      format.xml  { head :ok }
    end
  end
  def update_cities
    # updates songs based on artist selected
    state = State.find(params[:state_id])
    cities = state.cities
      render :update do |page|
      page.replace_html 'cities', :partial => 'cities', :object => cities
    end
  end

  
  private

  def load_data
    @states = State.all
    @cities = City.all
  end
end
