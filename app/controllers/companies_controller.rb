class CompaniesController < ApplicationController
  
  before_filter :authenticate_user!
  
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
        @email_setting = EmailSetting.new(:email => @contactinfo.email)
        @email_setting.company_id = @company.id
        @email_setting.save
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
      @email_setting = EmailSetting.find_by_company_id_and_email(@company.id, @contactinfo.email)
      @email_setting.update_attribute(:email => @contactinfo.email)
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
    @email_settings = @company.email_settings
    @emails = {}
    @email_settings.each do |email_setting|
      fetch_mail(email_setting.email, email_setting.decrypted_password, @company.id)
    end
    @emails = @company.emails
  end
  
  def fetch_mail(email, pswd, company_id)
    Mail.defaults do
      retriever_method :pop3, :address    => "pop.gmail.com",
                          :port       => 995,
                          :user_name  => email,
                          :password   => pswd,
                          :enable_ssl => true
    end
    emails = Mail.find(:what => :first, :count => 15, :order => :asc)
    emails.each do |email|
      
      if email.attachments.length > 0
      email.attachments.each do |tattch|
        fn = tattch.filename
        extension = File.extname(fn)
        if extension == ".doc" || extension == ".docx"
        @email = Email.new
        @email.from = email.from
        @email.resume_file = fn
        @email.company_id = company_id
        @email.date_received = email.date
        @email.save
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
    end
    emails
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
