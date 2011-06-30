class SkillsetsController < ApplicationController
  # GET /skillsets
  # GET /skillsets.xml
  def index
    @skillsets = Skillset.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skillsets }
    end
  end

  # GET /skillsets/1
  # GET /skillsets/1.xml
  def show
    @skillset = Skillset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @skillset }
    end
  end

  # GET /skillsets/new
  # GET /skillsets/new.xml
  def new
    @skillset = Skillset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @skillset }
    end
  end

  # GET /skillsets/1/edit
  def edit
    @skillset = Skillset.find(params[:id])
  end

  # POST /skillsets
  # POST /skillsets.xml
  def create
    @skillset = Skillset.new(params[:skillset])

    respond_to do |format|
      if @skillset.save
        format.html { redirect_to(@skillset, :notice => 'Skillset was successfully created.') }
        format.xml  { render :xml => @skillset, :status => :created, :location => @skillset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @skillset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skillsets/1
  # PUT /skillsets/1.xml
  def update
    @skillset = Skillset.find(params[:id])

    respond_to do |format|
      if @skillset.update_attributes(params[:skillset])
        format.html { redirect_to(@skillset, :notice => 'Skillset was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @skillset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skillsets/1
  # DELETE /skillsets/1.xml
  def destroy
    @skillset = Skillset.find(params[:id])
    @skillset.destroy

    respond_to do |format|
      format.html { redirect_to(skillsets_url) }
      format.xml  { head :ok }
    end
  end
end
