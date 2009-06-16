module CourseHelper

  # Toggle the value of a checkbox between T and F using AJAX
  def toggle_skill(object)
    remote_function(:url => url_for(object),
      :method   => :put,
      :before   => "Element.show('spinner')",
      :complete => "Element.hide('spinner')",
      :with     => "'skill[' + this.checked + ']=' + this.name")
  end
end