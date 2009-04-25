class GradesController < ApplicationController

  def index
    @courses = current_user.courses.active
  end
  
  def show
      
  end
  
end
