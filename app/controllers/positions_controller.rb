class PositionsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /positions
  # GET /positions.xml
 #  before_filter :authenticate_user!
  def index
    @company = Company.find(params[:company_id])
    @positions = @company.positions
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
    if current_user.user_type == "Company"
       @company = Company.find(params[:company_id])
       @city = Contactinfo.find(@company.contactinfos_id).city
    elsif current_user.user_type == "Agency"
       @agency = Agency.find(params[:agency_id])
    end
    
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
    @positionskillset = Positionskillset.find(@position.positionskillsets_id)
     
  end

  # POST /positions
  # POST /positions.xml
  def create
    
    load_data
    @position  = Position.new(params[:position])
    
      if current_user.user_type == "Company"
         @company = Company.find(params[:position][:company_id]) if params[:position][:company_id]
         @city = Contactinfo.find(@company.contactinfos_id).city
      elsif current_user.user_type == "Agency"
         @agency = Agency.find(params[:position][:agency_id]) if params[:position][:agency_id]
       
        end
        @positionskillset = Positionskillset.new(params[:positionskillset])
    
  
   
       @positionskillset.positions_id = @position.id
       @positionskillset.skillsets_id = @position.skillset_ids
       @positionskillset.save
       @position.positionskillsets_id = @positionskillset.id
       @position.status = 'Open'
       
      @position.save
    
#       
     
        if current_user.user_type == "Company"
           if params[:commit] == "SAVE"
             @position.city = @city
             @position.published_status = "0"
             @position.update_attributes(params[:position])
            if @position.save 
              flash[:notice] = "Position #{@position.title} was created successfully."
              redirect_to(@position)
            else
               render :action => "new"
            end
            
          elsif params[:commit] == "SAVEPUBLISH"
            if @position.save
             flash[:notice] = "Position #{@position.title} was created successfully."
             redirect_to("/savepublish?id=#{@position.id}")
            else
              render :action => "new"
            end
           
           
           
        
         elsif current_user.user_type == "Agency"
              @company_id = Company.find(@position.company_id).id
              @company = Company.find(@company_id)
              @company_city = Contactinfo.find(@company.contactinfos_id).city
              @position.city = @company_city
             
              positionagency = params[:position][:agency_id]
              agency = Agency.find(positionagency)
              @position.agencies << agency
              @position.published_status = "2"
              @position.save
          else
              render :action => "new"
            end
       
     end 
  end

  # PUT /positions/1
  # PUT /positions/1.xml
   def update
   load_data

    @position = Position.find(params[:id])
    @position.update_attributes(params[:position])
    if current_user.user_type == "Company"
         if params[:commit] == "UPDATE"
            if @position.status == "Open"

               if !@position.agency_ids.nil?
               @position.agency_ids = []
               @position.published_status = "0"
               @position.update_attributes(params[:position])
               Agency.any_in(:position_ids => [@position.id]).each do |p|
                     p.positions.delete(@position)
                     p.save
                     end

               else
                 @position.published_status = "0"
                 @position.update_attributes(params[:position])
               end
                if @position.update_attributes(params[:position])
                   flash[:notice] = "Position #{@position.title} was updated successfully."
                   redirect_to(@position)
                else
                    render :action => "edit"
    
                end
           elsif @position.status == "Close" || @position.status == "Inprogress"
                @position.agency_ids = []
                @position.published_status = "0"
                Agency.any_in(:position_ids => [@position.id]).each do |p|
                  p.positions.delete(@position)
                  p.save
                  end
                @position.update_attributes(params[:position])
                flash[:notice] = "Position #{@position.title} has been closed or in progress."
                redirect_to(@position)
          end
    elsif params[:commit] == "UPDATEPUBLISH"
          if @position.status == "Open"
             @position.update_attributes(params[:position])
             flash[:notice] = "Position #{@position.title} was updated successfully."
             redirect_to("/updatepublish?id=#{@position.id}")
          elsif @position.status == "Close" || @position.status == "Inprogress"
             @position.agency_ids = []
             @position.published_status = "0"
             Agency.any_in(:position_ids => [@position.id]).each do |p|
                p.positions.delete(@position)
                p.save
                end
            @position.update_attributes(params[:position])
             if @position.update_attributes(params[:position])
                   flash[:notice] = "Position #{@position.title} has been closed or in progress."
                  redirect_to("/updatepublish?id=#{@position.id}")
                else
                    render :action => "edit"
    
                end
           end 
         end 
      
   
  elsif current_user.user_type == "Agency"
            if @position.status == "Open"
               @position.published_status = "2"
               #@position.update_attributes(params[:position])
               if @position.update_attributes(params[:position])
                 redirect_to(@position)
                 flash[:notice] = "Position #{@position.title} was updated successfully."
               else
                 render :action => "edit"
                end 
           elsif @position.status == "Inprogress" || @position.status == "Close"
               @position.published_status = "0"
               @position.update_attributes(params[:position])
                 redirect_to(@position)
                 flash[:notice] = "Position #{@position.title} has been closed or in progress."
            end
     end       
 
end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])
 
       if !@position.agency_ids.nil?
           Agency.any_in(:position_ids => [@position.id]).each do |p|
           p.positions.delete(@position)
           p.save
           end
          @position.destroy
       else
         @position.destroy
       end
       respond_to do |format|
       format.html { redirect_to("/positions/#{params[:company_id]}/index") }
       end
    
   
  
  end

  
  def savepublish()
    
    if current_user.user_type == "Company"
       @position = Position.find(params[:id])
       
       @agencies = Agency.find(:all)
       @data = params[:publish_all]
       @data1 = params[:publish_agency]
       
       if (@data &&  @data1)
         @city = Contactinfo.find(@position.company.contactinfos_id).city
          @position.published_status = "3"
          @position.city = @city
          @position.update_attributes(params[:position])
          @arr = params[:position][:agency_ids]
          @arr.each do |a|
          agency = Agency.find(a)
          @position.agencies << agency
          @position.save
          end
          redirect_to(@position)
          flash[:notice] = "Public to all and agencies"
      elsif @data
          @city = Contactinfo.find(@position.company.contactinfos_id).city
          @position.published_status = "1"
          @position.city = @city
          @position.update_attributes(params[:position])
          redirect_to(@position)
          flash[:notice] = "Public to all"
      elsif @data1
          @city = Contactinfo.find(@position.company.contactinfos_id).city
          @position.published_status = "2"
          @position.city = @city
          @position.update_attributes(params[:position])
          @arr = params[:position][:agency_ids] 
          @arr.each do |a|
          agency = Agency.find(a)
          @position.agencies << agency
          @position.save
          end
          redirect_to(@position)
          flash[:notice] = "Public to agencies"
       end
       elsif current_user.user_type == "Agency"
          
           @position = Position.find(params[:id])
          if @position.published_status = '2'
           @position.published_status = "1"
           @position.update_attributes(params[:position])
           redirect_to(@position)
           flash[:notice] = "Public to all"
         elsif @position.published_status = '3' 
            redirect_to("/publish_agency?id=#{@position.id}")
           
         end  
      end  
 end   

 def publish_agency
     
      @position = Position.find(params[:id])
      @agencies = Agency.find(:all,:conditions => { :user_id => {'$ne'=> current_user.id}})
      if request.post?
      @position.published_status = "2"
      @arr = params[:position][:agency_ids]
         Agency.any_in(:position_ids => [@position.id]).each do |p|
             p.positions.delete(@position)
             p.save
            end
        @arr.each do |a|
        agency = Agency.find(a)
        @position.agencies << agency
        @position.update_attributes(params[:position])
        end
          
           redirect_to(@position)
           flash[:notice] = "Public to agencies"
       end 
 end
  
  def updatepublish
    @position = Position.find(params[:id])
    @agencies = Agency.all
    @data = params[:publish_all]
    @data1 = params[:publish_agency]
    if (@data &&  @data1) 
        @position.published_status = "3" 
        @arr = params[:position][:agency_ids]
         Agency.any_in(:position_ids => [@position.id]).each do |p|
             p.positions.delete(@position)
             p.save
            end
        @arr.each do |a|
        agency = Agency.find(a)
          @position.agencies << agency
          @position.update_attributes(params[:position])
        end
          
        redirect_to(@position)
        flash[:notice] = "Public to all and agencies"
   elsif @data
         @position.published_status = "1"
         @position.agency_ids= []
          @position.update_attributes(params[:position])
         redirect_to(@position)
         flash[:notice] = "Public to all"
    elsif @data1
         @position.published_status = "2" 
         @arr = params[:position][:agency_ids]
         Agency.any_in(:position_ids => [@position.id]).each do |p|
             p.positions.delete(@position)
             p.save
            end
          @arr.each do |a|
           agency = Agency.find(a)
            @position.agencies << agency
           @position.update_attributes(params[:position])
           end
         redirect_to(@position)
         flash[:notice] = "Public to agencies"
        end 
      
  end
 
  private
  def load_data
    @skillsets = Skillset.all
    
  end

end
