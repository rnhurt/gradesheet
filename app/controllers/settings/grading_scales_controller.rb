class Settings::GradingScalesController < SettingsController
  layout 'standard'

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
    
    respond_to do |format|
      format.html { render :action => :edit }
    end
  end


  def edit
    @scale = GradingScale.find(params[:id])
  end


  def create
    @scale = GradingScale.new(params[:grading_scale])

    respond_to do |format|
      if @scale.save
        flash[:notice] = "Grading scale '#{@scale.name}' was successfully created."
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @scale = GradingScale.find(params[:id])

    respond_to do |format|
      if @scale.update_attributes(params[:grading_scale])
        flash[:notice] = "Grading scale '#{@scale.name}' was successfully updated."
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "edit" }
      end
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
