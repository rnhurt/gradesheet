# This controller is used by the student/parent to access their grade information
class GradesController < ApplicationController

  def index
    @courses = current_user.courses.active
  end
  
  def show
      
  end
  
end
