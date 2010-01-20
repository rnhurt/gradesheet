class Settings::SupportingSkillsController < SettingsController
  before_filter :authorized?
  before_filter :find_skill, :only => [:show, :edit, :update, :destroy]

  def index
    @categories = SupportingSkillCategory.all
  end

  def new
    @skill = SupportingSkill.new
    render :action => :edit
  end

  def edit
    @skill_category = SupportingSkillCategory.find(@skill.supporting_skill_category_id)
  end

  def create
    @skill = SupportingSkill.new(params[:supporting_skill])
    @skill_category = SupportingSkillCategory.find(params[:supporting_skill][:supporting_skill_category_id])

    if @skill.save
      flash[:notice] = "Supporting skill was successfully created."
    else
      flash[:error] = "Supporting skill was not created."
    end

     render :action => :edit
  end


  def update
    respond_to do |format|
      if @skill.update_attributes(params[:supporting_skill])
        format.html {
          flash[:notice] = "Supporting skill was successfully updated."
          redirect_to :action => :edit,
          :controller => :supporting_skill_categories,
          :id => @skill.supporting_skill_category_id
        }
        format.js   { head :ok }
      else
        format.html {
          flash[:error] = "Supporting skill was not successfully updated."
          redirect_to :action => :edit
        }
        format.js   { head :unprocessable_entity }
      end
    end
  end

  def destroy
    if @skill.destroy
      flash[:notice] = "Supporting skill was successfully deleted."
    else
      flash[:error] = "Supporting skill was not deleted."
    end
    
    redirect_to :action => :edit,
      :controller => :supporting_skill_categories,
      :id => @skill.supporting_skill_category_id
  end

  private

  # Find the supporting skill
  def find_skill
    @skill = SupportingSkill.find(params[:id])
  end

end
