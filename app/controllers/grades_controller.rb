# This controller is used by the student/parent to access their grade information
class GradesController < ApplicationController

  def index
    @courses = current_user.courses.active  # needed for the side bar
    @school_year = SchoolYear.current_year
  end
  
  def show
    @courses = current_user.courses.active  # need for the side bar
    @course = Course.find(params[:id])
    @course.terms.sort!{|a,b| a.end_date <=> b.end_date}
    @school_year = SchoolYear.current_year
  end

  def edit
    # We redirect edit so that we can re-use the courses side bar
    redirect_to :action => "show"
  end
end
