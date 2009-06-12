class Settings::SupportingSkillCodesController < SettingsController
  before_filter :authorized?

  def index
    @skill_codes = SupportingSkillCode.find(:all)
  end

  def show
    @skill_code = SupportingSkillCode.find(params[:id])
  end


  def new
    @skill_code = SupportingSkillCode.new
    @valid_codes = SupportingSkillCode.valid_codes

    render :action => :edit
  end


  def edit
    @skill_code = SupportingSkillCode.find(params[:id])
    @valid_codes = SupportingSkillCode.valid_codes
  end


  def create
    @skill_code = SupportingSkillCode.new(params[:supporting_skill_code])

    if @skill_code.save
      flash[:notice] = "Supporting skill code was successfully created."
      redirect_to :action => :index
    else
      @valid_codes = SupportingSkillCode.valid_codes
      render :action => :edit
    end
  end


  def update
    @skill_code = SupportingSkillCode.find(params[:id])

		## If an alternate CODE is provided then use it instead
		if !params[:code1].empty?
			params[:supporting_skill_code][:code] = params[:code1]
		end
    
    if @skill_code.update_attributes(params[:supporting_skill_code])
      flash[:notice] = "Supporting skill code was successfully updated."
      redirect_to :action => :index
    else
      render :action => 'edit'
    end
  end


  def destroy
    @skill_code = SupportingSkillCode.find(params[:id])
    if @skill_code.destroy
      flash[:notice] = "Supporting skill code was successfully deleted."
    else
      flash[:error] = "Supporting skill code was not deleted."
    end
    
    redirect_to( supporting_skill_codes_url )
  end
  
end
