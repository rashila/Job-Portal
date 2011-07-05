class EmailSettingsController < ApplicationController
  # GET /email_settings
  # GET /email_settings.xml
  def index
    @company = Company.find(params[:company_id])
    @email_settings = @company.email_settings
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @email_settings }
    end
  end

  # GET /email_settings/1
  # GET /email_settings/1.xml
  def show
    @email_setting = EmailSetting.find(params[:id])
    @company = @email_setting.company
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email_setting }
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
  end

  # POST /email_settings
  # POST /email_settings.xml
  def create
    @email_setting = EmailSetting.new(params[:email_setting])
    @company = Company.find(params[:company_id])
    @email_setting.company_id =@company.id
    respond_to do |format|
      if @email_setting.save
        format.html { redirect_to([@company, @email_setting], :notice => 'Email setting was successfully created.') }
        format.xml  { render :xml => @email_setting, :status => :created, :location => @email_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /email_settings/1
  # PUT /email_settings/1.xml
  def update
    @email_setting = EmailSetting.find(params[:id])
    @company = Company.find(@email_setting.company_id)
    respond_to do |format|
      if @email_setting.update_attributes(params[:email_setting])
        format.html { redirect_to([@company, @email_setting], :notice => 'Email setting was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @email_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /email_settings/1
  # DELETE /email_settings/1.xml
  def destroy
    @email_setting = EmailSetting.find(params[:id])
    @email_setting.destroy

    respond_to do |format|
      format.html { redirect_to(email_settings_url) }
      format.xml  { head :ok }
    end
  end
end
