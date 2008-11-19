class StudentsController < ApplicationController
	layout "standard"
	
  def list

		items_per_page = 10

		sort = case params['sort']
		       when "name"  then "name"
		       when "qty"   then "quantity"
		       when "price" then "price"
		       when "name_reverse"  then "name DESC"
		       when "qty_reverse"   then "quantity DESC"
		       when "price_reverse" then "price DESC"
		       end

		conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

		@total = Item.count(:conditions => conditions)
		@items_pages, @items = paginate :items, :order => sort, :conditions => conditions, :per_page => items_per_page

		if request.xml_http_request?
		  render :partial => "items_list", :layout => false
		end

	end






  def index
    @students = Student.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end


  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end


  def new
    @student = Student.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end


  def edit
    @student = Student.find(params[:id])
  end


  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
        format.html { redirect_to(@student) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'Student was successfully updated.'
        format.html { redirect_to(students_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end
end
