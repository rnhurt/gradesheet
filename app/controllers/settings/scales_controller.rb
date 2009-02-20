class Settings::ScalesController < SettingsController
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
    @scale = GradingScale.new(params[:term])

    respond_to do |format|
      if @scale.save
        flash[:notice] = 'Scale was successfully created.'
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @scale = GradingScale.find(params[:id])

    respond_to do |format|
      if @scale.update_attributes(params[:term])
        flash[:notice] = 'Scale was successfully updated.'
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @scale = GradingScale.find(params[:id])
    @scale.destroy

    respond_to do |format|
      format.html { redirect_to(scales_url) }
    end
  end
end
