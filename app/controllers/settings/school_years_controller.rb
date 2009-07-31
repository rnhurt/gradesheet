class Settings::SchoolYearsController < SettingsController

  def index
    @years = SchoolYear.find(:all, :order => "end_date DESC", :include => :terms)
  end

  def show
    @year = SchoolYear.find(params[:id])
  end


  def new
    @year = SchoolYear.new
    @year.terms.build
  end


  def edit
    @year = SchoolYear.find(params[:id])
  end


  def create
    @year = SchoolYear.new(params[:school_year])

    if @year.save
      flash[:notice] = "School year '#{@year.name}' was successfully created."
      redirect_to grading_periods_path
    else
      flash[:error] = "Failed to create school year."
      render :action => "new"
    end
  end

  def update
    params[:school_year][:existing_term_attributes] ||= {}

    @year = SchoolYear.find(params[:id])
    if @year.update_attributes(params[:school_year])
      flash[:notice] = "School year '#{@year.name}' was successfully updated."
      redirect_to :action => :index 
    else
      render :action => "edit"
    end
  end


  def destroy
    @year = SchoolYear.find(params[:id])
    if @year.destroy
      flash[:notice] = "School year '#{@year.name}' was successfully deleted."
    else
      flash[:error] = "School year '#{@year.name}' could not be deleted."
    end
    redirect_to :action => :index
  end
end
