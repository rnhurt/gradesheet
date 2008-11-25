class AssignmentsController < ApplicationController
	layout "standard"

	
  def index
    @courses = Course.find(:all, :conditions => { :teacher_id => current_user })

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end


  def show
		@assignments = Assignment.find(:all, :include => [:course],
													:conditions => { :course_id => params[:id]})

	  respond_to do |format|
	    format.html # show.html.erb
	    format.xml  { render :xml => @assignment }
	    format.js		{ render :partial => "assignment_list" }
	  end
  end


  def new
    @assignment = Assignment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignment }
    end
  end


  def edit
    @assignment = Assignment.find(params[:id])
  end


  def create
    @assignment = Assignment.new(params[:assignment])

    respond_to do |format|
      if @assignment.save
        flash[:notice] = 'Assignment was successfully created.'
        format.html { redirect_to(@assignment) }
        format.xml  { render :xml => @assignment, :status => :created, :location => @assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assignments/1
  # PUT /assignments/1.xml
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        flash[:notice] = 'Assignment was successfully updated.'
        format.html { redirect_to(assignments_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(assignments_url) }
      format.xml  { head :ok }
    end
  end
end
