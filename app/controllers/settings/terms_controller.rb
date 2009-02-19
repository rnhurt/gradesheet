class Settings::TermsController < SettingsController
  # GET /terms
  # GET /terms.xml
  def index
    @terms = Term.find(:all, :order => "begin_date DESC")

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /terms/1
  # GET /terms/1.xml
  def show
    @term = Term.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /terms/new
  # GET /terms/new.xml
  def new
    @term = Term.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /terms/1/edit
  def edit
    @term = Term.find(params[:id])
  end

  # POST /terms
  # POST /terms.xml
  def create
    @term = Term.new(params[:term])

    respond_to do |format|
      if @term.save
        flash[:notice] = 'Term was successfully created.'
        format.html { redirect_to(@term) }
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
