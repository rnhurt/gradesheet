class GradationsController < ApplicationController
	layout "standard"
	
  def show
    @gradation = Course.find(params[:id], :include => :assignments, :include => :students, :include => :gradations)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gradation }
    end
  end


  def new
    @gradation = Gradation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gradation }
    end
  end


  def edit
    @gradation = Gradation.find(params[:id])
  end


  def create
    @gradation = Gradation.new(params[:gradation])

    respond_to do |format|
      if @gradation.save
        flash[:notice] = 'Gradation was successfully created.'
        format.html { redirect_to(@gradation) }
        format.xml  { render :xml => @gradation, :status => :created, :location => @gradation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gradation.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @gradation = Gradation.find(params[:id])

    respond_to do |format|
      if @gradation.update_attributes(params[:gradation])
        flash[:notice] = 'Gradation was successfully updated.'
        format.html { redirect_to(@gradation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gradation.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @gradation = Gradation.find(params[:id])
    @gradation.destroy

    respond_to do |format|
      format.html { redirect_to(gradations_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_grade
  end
end
