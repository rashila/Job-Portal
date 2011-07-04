class CompaniesController < ApplicationController
  def welcome
    @company = Company.find(params[:id])
  end
  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    load_data
    @company = Company.new
    @contactinfo = Contactinfo.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /companies/1/edit
  def edit
    load_data
    @company = Company.find(params[:id])
    @contactinfo= Contactinfo.find(@company.contactinfos_id)
  end

  # POST /companies
  # POST /companies.xml
  def create
    load_data
    @company = Company.new(params[:company])
    @contactinfo = Contactinfo.new(params[:contactinfo])
    @company.valid?
    @contactinfo.valid?
    @company.user_id = current_user.id
    respond_to do |format|
      if @company.errors.length == 0 and @contactinfo.errors.length == 0
        @contactinfo.save(:validate => false)
        @company.contactinfos_id = @contactinfo.id
        @company.save(:validate => false)
        format.html { redirect_to(@company) }
        flash[:notice] = "Company #{@company.name} was created successfully."
        format.xml  { render :xml => @company, :status => :created, :location => @company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @company.errors + @contactinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    load_data
    @company = Company.find(params[:id])
    @contactinfo = Contactinfo.find(@company.contactinfos_id)
    if @contactinfo.update_attributes(params[:contactinfo])
      contactinfo_success = 1
    end
    if @company.update_attributes(params[:company])
      company_success = 1
    end
    respond_to do |format|
      if contactinfo_success == 1 and company_success == 1
        format.html { redirect_to(@company) }
        flash[:notice] = "Company #{@company.name} was successfully updated." 
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @company.errors+@contactinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(companies_url) }
      format.xml  { head :ok }
    end
  end
  
  def company_resumes
    @company = Company.find(params[:id])
    company_email = Contactinfo.find(@company.contactinfos_id).email
    Mail.defaults do
    retriever_method :pop3, :address    => "pop.gmail.com",
                          :port       => 995,
                          :user_name  => company_email,
                          :password   => 'fsrashila',
                          :enable_ssl => true
    end
    @emails = Mail.all
    @emails.each do |email|
      email.attachments.each do |tattch|
        fn = tattch.filename
        begin
          if !File.directory? "public/email/resume/"+params[:id]
            Dir.mkdir("public/email/resume/"+params[:id])
          end
          if File::exists?("public/email/resume/"+params[:id]+"/"+fn)
            File.open("public/email/resume/"+params[:id]+"/"+email.message_id+"_"+fn, "w+b", 0644 ) { |f| f.write tattch.body.decoded }
          else
            File.open("public/email/resume/"+params[:id]+"/"+fn, "w+b", 0644 ) { |f| f.write tattch.body.decoded }
          end
        rescue Exception => e
          logger.error "Unable to save data for #{fn} because #{e.message}"
        end
      end
    end
  end
  
  def resume_download
    if params[:type] == "email"
      send_file "public/email/resume/"+params[:id]+"/"+params[:attached_file_name]+"."+params[:format], :disposition => 'inline'
    elsif params[:type] == "Candidate"
      @candidate = Candidate.find(params[:id])
      send_file "public"+@candidate.resume.url, :disposition => 'inline' 
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
    @skillsets = Skillset.find(:all)
    @states = State.all
    @cities = City.all
  end
end
