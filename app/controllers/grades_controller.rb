# This controller is used by the student/parent to access their grade information
class GradesController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?

  def index
    @school_year = SchoolYear.current_year
    @courses = current_user.courses.by_school_year(@school_year)  # need for the side bar
  end
  
  def show
    @school_year = SchoolYear.current_year
    @courses = current_user.courses.by_school_year(@school_year)  # need for the side bar
    @course = Course.find(params[:id])
    @course.terms.sort!{|a,b| a.end_date <=> b.end_date}
  end

  def edit
    # We redirect edit so that we can re-use the courses side bar
    redirect_to :action => "show"
  end
end
