class EnrollmentsController < ApplicationController
  def index
    @enrollments = Enrollment.find(:all)
		
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @enrollments }
    end
  end


  def show
    @enrollment = Enrollment.find(params[:id])
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @enrollment }
    end
  end


  def new
    @enrollment = Enrollment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @enrollment }
    end
  end


  def edit
    @enrollment = Enrollment.find(params[:id])
  end


  def create
    @enrollment = Enrollment.new(params[:enrollment])

    respond_to do |format|
      if @enrollment.save
        flash[:notice] = 'Enrollment was successfully created.'
        format.html { redirect_to(@enrollment) }
        format.xml  { render :xml => @enrollment, :status => :created, :location => @enrollment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @enrollment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @enrollment = Enrollment.find(params[:id])

    respond_to do |format|
      if @enrollment.update_attributes(params[:enrollment])
        flash[:notice] = 'Enrollment was successfully updated.'
        format.html { redirect_to(@enrollment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @enrollment.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @enrollment = Enrollment.find(params[:id])
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to(enrollments_url) }
      format.xml  { head :ok }
    end
  end
end
