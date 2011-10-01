class Settings::SchoolYearsController < SettingsController
  after_filter :expire_cache, :only => [:create, :update, :destroy]

  def index
    # Due to the way SchoolYear objects are built, we have to sort them and limit them
    # when they are used instead of in the Model where it should be.  :(
    @years = SchoolYear.all(:include => :terms).sort! { |x,y| y.end_date <=> x.end_date } [0..5]
  end

  def show
    @year = SchoolYear.find(params[:id], :include => :terms)
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

  private

  def expire_cache
    expire_fragment %r{course_list_*}   # Expire all the course caches
  end
end
