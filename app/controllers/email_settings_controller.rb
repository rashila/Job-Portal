class EmailSettingsController < ApplicationController
  # GET /email_settings
  # GET /email_settings.xml
 def index
  if current_user.user_type == "Company" 
    @company = Company.find(params[:company_id])
    @email_settings = @company.email_settings

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_settings }
    end
   elsif current_user.user_type == "Agency"
     @agency = Agency.find(params[:agency_id])
     @email_settings = @agency.email_settings

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_settings }
    end
     
   end
  end

  # GET /email_settings/1
  # GET /email_settings/1.xml
 def show
   if current_user.user_type == "Company"   
      @email_setting = EmailSetting.find(params[:id])
      @company = @email_setting.company
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @email_setting }
        end
   elsif current_user.user_type == "Agency"
      @email_setting = EmailSetting.find(params[:id])
      @agency = @email_setting.agency
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @email_setting }
        end
   end
 end

  # GET /email_settings/new
  # GET /email_settings/new.xml
  def new
    @email_setting = EmailSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email_setting }
    end
  end

  # GET /email_settings/1/edit
  def edit
    @email_setting = EmailSetting.find(params[:id])
    @company = @email_setting.company
    @email_setting.password = @email_setting.decrypted_password
  end

  # POST /email_settings
  # POST /email_settings.xml
  def create
   if current_user.user_type == "Company" 
    @email_setting = EmailSetting.new(params[:email_setting])
    password = params[:email_setting][:password]
    @email_setting.password = @email_setting.encrypted_password(params[:email_setting][:password]) if params[:email_setting][:password].length > 0
    @company = Company.find(params[:company_id])
    @email_setting[:company_id] = @company.id
    respond_to do |format|
      if @email_setting.save
        format.html { redirect_to([@company, @email_setting], :notice => 'Email setting was successfully created.') }
        format.xml  { render :xml => @email_setting, :status => :created, :location => @email_setting }
      else
        @email_setting.password = password
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_setting.errors, :status => :unprocessable_entity }
      end
    end
   elsif current_user.user_type == "Agency"
     @email_setting = EmailSetting.new(params[:email_setting])
    password = params[:email_setting][:password]
    @email_setting.password = @email_setting.encrypted_password(params[:email_setting][:password]) if params[:email_setting][:password].length > 0
    @agency = Agency.find(params[:agency_id])
    @email_setting[:agency_id] = @agency.id
    respond_to do |format|
      if @email_setting.save
        format.html { redirect_to([@agency, @email_setting], :notice => 'Email setting was successfully created.') }
        format.xml  { render :xml => @email_setting, :status => :created, :location => @email_setting }
      else
        @email_setting.password = password
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_setting.errors, :status => :unprocessable_entity }
      end
    end
  end
 end
  # PUT /email_settings/1
  # PUT /email_settings/1.xml
  def update
   if current_user.user_type == "Company"
    @email_setting = EmailSetting.find(params[:id])
    @company = Company.find(@email_setting.company_id)
    password = params[:email_setting][:password]
    params[:email_setting][:password] = @email_setting.encrypted_password(params[:email_setting][:password]) if params[:email_setting][:password].length > 0
    respond_to do |format|
      if @email_setting.update_attributes(params[:email_setting])
        
        format.html { redirect_to([@company, @email_setting], :notice => 'Email setting was successfully updated.') }
        format.xml  { head :ok }
      else
        @email_setting.password = password
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_setting.errors, :status => :unprocessable_entity }
      end
    end
   elsif current_user.user_type == "Agency"
     @email_setting = EmailSetting.find(params[:id])
     @agency = Agency.find(@email_setting.agency_id)
    password = params[:email_setting][:password]
    params[:email_setting][:password] = @email_setting.encrypted_password(params[:email_setting][:password]) if params[:email_setting][:password].length > 0
    respond_to do |format|
      if @email_setting.update_attributes(params[:email_setting])
        
        format.html { redirect_to([@agency, @email_setting], :notice => 'Email setting was successfully updated.') }
        format.xml  { head :ok }
      else
        @email_setting.password = password
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_setting.errors, :status => :unprocessable_entity }
      end
    end
   end
  end

  # DELETE /email_settings/1
  # DELETE /email_settings/1.xml
  def destroy
   if current_user.user_type == "Company"
     @email_setting = EmailSetting.find(params[:id])
     @company = @email_setting.company
     @email_setting.destroy

     respond_to do |format|
       format.html { redirect_to(company_email_settings_url(@company)) }
       format.xml  { head :ok }
     end
    end
   else if current_user.user_type == "Agency"
     @email_setting = EmailSetting.find(params[:id])
     @company = @email_setting.company
     @email_setting.destroy

     respond_to do |format|
       format.html { redirect_to(company_email_settings_url(@company)) }
       format.xml  { head :ok }
     end
    end
   end
  
end
