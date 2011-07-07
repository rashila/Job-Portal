class EmailsController < ApplicationController
  # DELETE /email/1
  # DELETE /email/1.xml
  def destroy
    @email = Email.find(params[:id])
    @company = @email.company
    @email.destroy

    respond_to do |format|
      format.html { redirect_to(company_resumes_url(@company)) }
      format.xml  { head :ok }
    end
  end
end
