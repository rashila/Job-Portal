class CandidatesController < ApplicationController
  # GET /candidates
  # GET /candidates.xml
  def index
      @candidates = Candidate.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @candidates }
    end
  end

  # GET /candidates/1
  # GET /candidates/1.xml
  def show
    @candidate = Candidate.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @candidate }
    end
  end

  # GET /candidates/new
  # GET /candidates/new.xml
  def new
    puts 'newwwwwwwwwwww'
    @candidate = Candidate.new
    @contactinfo = Contactinfo.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @candidate }
    end
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.find(params[:id])
    @contactinfo = Contactinfo.find(@candidate.contactinfos_id)
  end

  # POST /candidates
  # POST /candidates.xml
  def create
    @candidate = Candidate.new(params[:candidate])
    @contactinfo = Contactinfo.new(params[:contactinfo])
    @contactinfo.save
    @candidate.contactinfos_id = @contactinfo.id
   
#    @candidate.qualification = params[:qualification]
    respond_to do |format|
      if @candidate.save(:validate => false) && @contactinfo.save 
        puts '1111111111111'
        format.html { redirect_to(@candidate) }
        flash[:notice] = "Candidate #{@candidate.name} was created successfully."
        format.xml  { render :xml => @candidate, :status => :created, :location => @candidate }
      else
        puts '222222222222222'
        format.html { render :action => "new" }
        format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /candidates/1
  # PUT /candidates/1.xml
  def update
    @candidate = Candidate.find(params[:id])
    @contactinfo = Contactinfo.find(@candidate.contactinfos_id)
    @contactinfo.update_attributes(params[:contactinfo])
      if @candidate.update_attributes(params[:candidate]) && @contactinfo.update_attributes(params[:contactinfo])
       #format.html { redirect_to(@candidate) }
        flash[:notice] = "Candidate #{@candidate.name} was updated   successfully."
        redirect_to "/candidates"
       # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @candidate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.xml
  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to(candidates_url) }
      format.xml  { head :ok }
    end
  
end
