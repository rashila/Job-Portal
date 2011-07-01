module ApplicationHelper
   def load_address(args)
    @address = Contactinfo.find(args[:id]).address
  end
end
