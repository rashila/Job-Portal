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
    @candidate.valid?
    @contactinfo.valid?
    respond_to do |format|
      if @candidate.errors.length == 0 and @contactinfo.errors.length == 0
        @contactinfo.save(:validate => false)
        @candidate.contactinfos_id = @contactinfo.id
        @candidate.save(:validate => false)
        format.html { redirect_to(@candidate) }
        flash[:notice] = "Candidate #{@candidate.name} was created successfully."
        format.xml  { render :xml => @candidate, :status => :created, :location => @candidate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @candidate.errors + @contactinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /candidates/1
  # PUT /candidates/1.xml
  def update
    @candidate = Candidate.find(params[:id])
    @contactinfo = Contactinfo.find(@candidate.contactinfos_id)
    if @contactinfo.update_attributes(params[:contactinfo])
      contactinfo_success = 1
    end
    if @candidate.update_attributes(params[:candidate])
      candidate_success = 1
    end
    respond_to do |format|
      if contactinfo_success == 1 and candidate_success == 1
        format.html { redirect_to(@candidate) }
        flash[:notice] = "Candidate #{@candidate.name} was successfully updated." 
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @candidate.errors+@contactinfo.errors, :status => :unprocessable_entity }
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
end
