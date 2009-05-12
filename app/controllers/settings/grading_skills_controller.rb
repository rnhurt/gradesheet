class Settings::GradingSkillsController < SettingsController
  before_filter :authorized?

  def index
    @skills = GradingSkill.find(:all)
  end

  def show
    @skill = GradingSkill.find(params[:id])
  end


  def new
    @skill = GradingSkill.new

    render :action => :edit
  end


  def edit
    @skill = GradingSkill.find(params[:id])
    @valid_symbols = GradingSkill.valid_symbols
  end


  def create
    @skill = GradingSkill.new(params[:grading_skill])

    if @skill.save
      flash[:notice] = "Grading skill was successfully created."
      redirect_to :action => :index
    else
      render :action => 'new'
    end
  end


  def update
    @skill = GradingSkill.find(params[:id])
    @valid_symbols = GradingSkill.valid_symbols
    
    if @skill.update_attributes(params[:grading_skill])
      flash[:notice] = "Grading skill was successfully updated."
      redirect_to :action => :index
    else
      render :action => 'edit'
    end
  end


  def destroy
    @skill = GradingSkill.find(params[:id])
    if @skill.destroy
      flash[:notice] = "Grading skill was successfully deleted."    
    else
      flash[:error] = "Grading skill was not deleted."
    end
    
    redirect_to( grading_skills_url )
  end
  
end
