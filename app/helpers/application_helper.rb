module ApplicationHelper



  def title(page_title)
    content_for(:title) { page_title }
  end
  
 # def app_set(key)
 #   retrun Settings.find_by_key(key).value
 # end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Bynet Small Cloud Tool"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
