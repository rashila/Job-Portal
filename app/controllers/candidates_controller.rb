class CandidatesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def welcome
    @candidate = Candidate.find(params[:id])
    @positions = Position.find(:all)
     @skillsets = Skillset.all
  end
  
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
    @skillset = @candidate.skillsets
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @candidate }
    end
  end

  # GET /candidates/new
  # GET /candidates/new.xml
  def new
    load_data
    @candidate = Candidate.new
    
    @candidateskill = Candidateskill.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @candidate }
    end
  end

  # GET /candidates/1/edit
  def edit
    load_data
    @candidate = Candidate.find(params[:id])
    #@contactinfo = Contactinfo.find(@candidate.contactinfos_id)
  end

  # POST /candidates
  # POST /candidates.xml
  def create
    load_data
    
    @candidate = Candidate.new(params[:candidate])
   
    @candidateskill = Candidateskill.new(params[:candidateskill])
    @candidate.user_id = current_user.id
    @candidate.valid?
    
      if @candidate.errors.length == 0 
        @candidateskill.candidates_id = @candidate.id
        @candidateskill.skillsets_id = @candidate.skillset_ids
        @candidateskill.save
        @candidate.candidateskills_id = @candidateskill.id
        @candidate.save(:validate => false)
         if params[:commit] == "SAVE"
            flash[:notice] = "Candidate #{@candidate.name} was created successfully."
            redirect_to(@candidate)
         elsif params[:commit] == "SAVE&CONTINUE"
       
          
            flash[:notice] = "Candidate #{@candidate.name} was created successfully."
            redirect_to("/contactinfo?id=#{@candidate.id}")
        end  
    else
      render :action => "new"
    end
  end

  # PUT /candidates/1
  # PUT /candidates/1.xml
  def update
    load_data
    
    @candidate = Candidate.find(params[:id])
    #@contactinfo = Contactinfo.find(@candidate.contactinfos_id)
    @candidateskill = Candidateskill.find(@candidate.candidateskills_id)
    
    if @candidate.update_attributes(params[:candidate])
    candidate_success = 1
    end
    respond_to do |format|
      if candidate_success == 1
         if params[:commit] == "SAVE"
           format.html { redirect_to("/candidates/"+@candidate.id.to_s+"/welcome") }
           flash[:notice] = "Candidate #{@candidate.name} was successfully updated."
           format.xml  { head :ok }
         elsif params[:commit] == "SAVE&CONTINUE"
            format.html { redirect_to("/contactinfo_update?id=#{@candidate.id}") }
            flash[:notice] = "Candidate #{@candidate.name} was successfully updated."
            format.xml  { head :ok }
            
          end  
        
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
    @contactinfo = Contactinfo.find(@candidate.contactinfos_id)
    @candidateskill = Candidateskill.find(@candidate.candidateskills_id)
    @contactinfo.destroy
    @candidate.destroy
    
    @candidateskill.destroy

    respond_to do |format|
      format.html { redirect_to(candidates_url) }
      format.xml  { head :ok }
    end
  end

  def add
    @skillset = Skillset.find(params[:id])
    @candidate = @skillset.save
  end

  def download_candidate_resume
    @candidate = Candidate.find(params[:id])
    send_file "public"+@candidate.resume.url, :disposition => 'inline' 
  end
  def update_cities
    # updates cities based on state selected
    state = State.find(params[:state_id])
    cities = state.cities
      render :update do |page|
      page.replace_html 'cities', :partial => 'cities', :object => cities
    end
   end
    def search
             load_data
               @candidate = Candidate.find(params[:id])
               @search = Position.search do
          
                keywords(params[:title]) 
                keywords(params[:experience]) 
                keywords(params[:skillset_names]) 
                keywords(params[:city]) 
                with (:status,'Open')
                with (:published_status,'1')
 
       end
         
   end
   def contactinfo   
      load_data
      @candidate = Candidate.find(params[:id])
      @contactinfo = Contactinfo.new
      
      
    end  
    def contactinfo_update 
      load_data
      @candidate = Candidate.find(params[:id])
      if !@candidate.contactinfos_id.nil?
          @contactinfo = Contactinfo.find(@candidate.contactinfos_id)
       elsif @candidate.contactinfos_id.nil?
         redirect_to("/contactinfo?id=#{@candidate.id}")
       end
      
    end  
   def savecontinue
      @candidate = Candidate.find(params[:id])
      @contactinfo = Contactinfo.new(params[:contactinfo])
      
      @contactinfo.valid?
      if @contactinfo.errors.length == 0
         @contactinfo.save(:validate => false)
         @candidate.contactinfos_id = @contactinfo.id
         @candidate.update_attributes(params[:candidate])
         flash[:notice]= "Contact Information for #{@candidate.name} has been saved successfully"
         redirect_to(@candidate)
      end
      
   end
   
   def updatecontinue
         @candidate = Candidate.find(params[:id])
         @contactinfo = Contactinfo.find(@candidate.contactinfos_id)
          if @contactinfo.update_attributes(params[:contactinfo])
         
         flash[:notice]= "Contact Information for #{@candidate.name} has been updated successfully"
         redirect_to(@candidate)
      end
   end
   
   def apply
     @position = Position.find(params[:id])
     @candidateposition = CandidatePosition.new
   end 
   
   def position_apply
      @position = Position.find(params[:id])
      @candidate = current_user.candidate
      @candidateposition = CandidatePosition.new(params[:candidateposition])
      @candidateposition.position_id = @position.id
      @candidateposition.candidate_id = @candidate.id
      @candidateposition.title = @position.title
      @candidateposition.apply_status = "0"
      @candidateposition.save
     # position_ids = Array.new
     # puts "@@@@@@@@@@@@@@222"
     # puts params[:candidate][:position_ids].inspect
     # exit
          
       # @arr = params[:candidate][:position_ids]
          # @arr.each do |a|
          # position = Position.find(a)
          # @candidate.positions << positon
          # @candidate.save
          # end
      @candidate.position_ids = @position.id
      @candidate.update_attributes(params[:candidate])
      @position.candidate_ids = @candidate.id
      @position.update_attributes(params[:position])
        redirect_to("/applied?id=#{@position.id}")
       
      end  
      
    def applied
        @position = Position.find(params[:id])
        @candidate = current_user.candidate
       flash[:notice] = "Applied for position #{@position.title}"
      end  
   
  private

  def load_data
    @skillsets = Skillset.find(:all)
    @states = State.all
    @cities = City.find(:all).asc(:name)
    

   
    
  end
end
