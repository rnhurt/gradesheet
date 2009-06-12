class Settings::SupportingSkillCategoriesController < SettingsController
  before_filter :authorized?

  def index
    @skill_categories = SupportingSkillCategory.all
  end

  def show
    @skill_category = SupportingSkillCategory.find(params[:id])
    @skills = SupportingSkill.find(:all, :conditions => {:supporting_skill_category_id => params[:id]})
  end


  def new
    @skill_category = SupportingSkillCategory.new

    render :action => :edit
  end


  def edit
    @skill_category = SupportingSkillCategory.find(params[:id])
    @skills = SupportingSkill.find(:all, :conditions => {:supporting_skill_category_id => params[:id]})
  end


  def create
    @skill_category = SupportingSkillCategory.new(params[:supporting_skill_category])

    if @skill_category.save
      flash[:notice] = "Supporting skill category '#{@skill_category.name}' was successfully created."
      render :action => :edit
    else
      flash[:error] = "Supporting skill category was not created."
      redirect_to :action => :index
    end

  end


  def update
    @skill_category = SupportingSkillCategory.find(params[:id])

    if @skill_category.update_attributes(params[:supporting_skill_category])
      flash[:notice] = "Supporting skill category '#{@skill_category.name}' was successfully updated."
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end


  def destroy
    @skill_category = SupportingSkillCategory.find(params[:id])
    if @skill_category.destroy
      flash[:notice] = "Supporting skill category '#{@skill_category.name}' was successfully deleted."
    else
      flash[:error] = "Supporting skill category '#{@skill_category.name}' was not deleted."
    end
    
    redirect_to :action => :index
  end
  
end
