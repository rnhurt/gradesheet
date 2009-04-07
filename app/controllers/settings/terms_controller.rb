class Settings::TermsController < SettingsController

  def index
    @terms = Term.find(:all, :order => "begin_date DESC")

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @term = Term.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @term = Term.new

    respond_to do |format|
      format.html { render :action => :edit }
    end
  end


  def edit
    @term = Term.find(params[:id])
  end


  def create
    @term = Term.new(params[:term])

    respond_to do |format|
      if @term.save
        flash[:notice] = 'Term was successfully created.'
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.xml
  def update
    @term = Term.find(params[:id])

    respond_to do |format|
      if @term.update_attributes(params[:term])
        flash[:notice] = 'Term was successfully updated.'
        format.html { redirect_to :action => :index }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.xml
  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to(terms_url) }
    end
  end
end
