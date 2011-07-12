class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    if current_user.user_type == "Company"
      if !Company.exists?(:conditions => { :user_id => current_user.id })
        new_company_path 
      else
        company_welcome_path(current_user.company.id)
      end
    elsif current_user.user_type == "Candidate"
      if !Candidate.exists?(:conditions => { :user_id => current_user.id })
        new_candidate_path 
      else
        candidate_welcome_path(current_user.candidate.id)
      end
      elsif current_user.user_type == "Agency"
      if !Agency.exists?(:conditions => { :user_id => current_user.id })
        new_agency_path 
      else
        agency_welcome_path(current_user.agency.id)
      end
    end
  end
end
