class Settings::SitesController < SettingsController

  def index
    @sites = Site.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @site = Site.new

    respond_to do |format|
      format.html { render :action => :edit }
    end
  end


  def edit
    @site = Site.find(params[:id])
  end


  def create
    @site = Site.new(params[:site])

    if @site.save
      flash[:notice] = "Campus '#{@site.name}' was successfully created."
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def update
    @site = Site.find(params[:id])

    if @site.update_attributes(params[:site])
      flash[:notice] = "Campus '#{@site.name}' was successfully updated."
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @site = Site.find(params[:id])

    if @site.destroy
      flash[:notice] = "Campus '#{@site.name}' was successfully deleted."
      redirect_to :action => "index"
    end
  end
end
