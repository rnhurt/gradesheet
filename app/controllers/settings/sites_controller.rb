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

    respond_to do |format|
      if @site.save
        flash[:notice] = "Campus '#{@site.name}' was successfully created."
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => :edit  }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = "Campus '#{@site.name}' was successfully updated."
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
    end
  end
end
