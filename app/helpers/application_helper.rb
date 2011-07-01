module ApplicationHelper
  def load_address(args)
    @address = Contactinfo.find(args[:id]).address
  end
  
  def link_to_resume(resume, id, type)
    extension = File.extname(resume)
    filename = File.basename(resume, extension)
    link_to resume, resume_download_path(id, type, filename, extension.gsub(/\./, ''))
  end
end
