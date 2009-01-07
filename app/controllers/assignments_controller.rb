class AssignmentsController < ApplicationController
	layout "standard"

	
  def index
    @courses = Course.find_by_owner(:all, current_user)
    @terms = Term.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def show
  	@course	= Course.find(:course_id)
		@assignments = Assignment.find(:all, :include => [:course], :conditions => { :course_id => params[:id]})

	  respond_to do |format|
			format.html	#{ redirect_to :action => :index }					# Don't show an individual assignment
	    format.js		{ render :partial => "assignment_list" }	# Render the list of assignments for a course
	  end
  end


  def new
    @assignment = Assignment.new
    @courses = Course.find_by_owner(:all, current_user, :include => [:term])
    @course = Course.find(params[:course_id])
#    @course = params[:id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignment }
    end
  end


  def edit
    @course = Course.find(params[:id])
    @courses = Course.find_by_owner(:all, current_user, :include => [:term])
    @assignments = @course.assignments

    respond_to do |format|
    	format.html
	  end
  end


  def create
    @assignment = Assignment.new(params[:assignment])

    respond_to do |format|
      if @assignment.save
        flash[:notice] = 'Assignment #{@assignment.name} was created successfully.'
#        format.html { redirect_to(assignments_url) }
        format.html { redirect_to :action => :edit, :id => @assignment.course_id }
        format.xml  { render :xml => @assignment, :status => :created, :location => @assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

=begin
	# FIXME - I dont think this is used at all.  Please remove.
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        flash[:notice] = 'Assignment #{@assignment.name} was updated successfully.'
        format.html { redirect_to(assignments_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end
=end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(assignments_url) }
      format.xml  { head :ok }
    end
  end
  
end
