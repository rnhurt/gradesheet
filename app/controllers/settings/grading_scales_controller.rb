class Settings::GradingScalesController < SettingsController
  before_filter :authorized?

  def index
    @scales = GradingScale.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @scale = GradingScale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @scale = GradingScale.new
    5.times{ @scale.grade_ranges.build }  # Create a couple of grade ranges as a default

    respond_to do |format|
      format.html { render :action => :edit }
    end
  end


  def edit
    @scale = GradingScale.find(params[:id])
  end


  def create
    @scale = GradingScale.new(params[:grading_scale])

    if @scale.save
      flash[:notice] = "Grading scale '#{@scale.name}' was successfully created."
      redirect_to :action => :index
    else
      render :action => 'new'
    end
  end

  def update
# debugger
    params[:grading_scale][:existing_range_attributes] ||= {}
    @scale = GradingScale.find(params[:id])

    if @scale.update_attributes(params[:grading_scale])
      flash[:notice] = "Grading scale '#{@scale.name}' was successfully updated."
      redirect_to :action => :index
    else
      render :action => 'edit'
    end
  end

  def destroy
    @scale = GradingScale.find(params[:id])
    if @scale.destroy
      flash[:notice] = "Grading scale '#{@scale.name}' was successfully deleted."    
    else
      flash[:error] = "Grading scale '#{@scale.name}' was not deleted."
    end
    
    respond_to do |format|
      format.html { redirect_to( grading_scales_url ) }
    end
  end
end
