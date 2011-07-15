module ReviewsHelper
  def reviews_display(_reviews)
    html = content_tag(:div,
    _reviews.blank? ? "<h3>No reviews currently available</h3>" : render(:partial => _reviews), :class => "reviews")
  end

  def new_review_link
    link_to 'Create a new review', new_review_path()
  end
end
