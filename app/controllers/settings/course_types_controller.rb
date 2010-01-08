class Settings::CourseTypesController < SettingsController
  before_filter :authorized?

  def index
    @course_types = CourseType.all
  end

  def show
    @course_type = CourseType.find(params[:id])
  end

  def new
    @course_type = CourseType.new

    render :action => :edit
  end

  def edit
    @course_type = CourseType.find(params[:id])
  end


  def create
    @course_type = CourseType.new(params[:course_type])

    if @course_type.save
      flash[:notice] = "Course type '#{@course_type.name}' was successfully created."
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def update
    @course_type = CourseType.find(params[:id])

    if @course_type.update_attributes(params[:course_type])
      flash[:notice] = "Grading scale '#{@course_type.name}' was successfully updated."
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @course_type = CourseType.find(params[:id])
    if @course_type.destroy
      flash[:notice] = "Course type '#{@course_type.name}' was successfully deleted."
    else
      flash[:error] = "Course type '#{@course_type.name}' was not deleted."
    end
    
    redirect_to course_types_url
    
  end
end
