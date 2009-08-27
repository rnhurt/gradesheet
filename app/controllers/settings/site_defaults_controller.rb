class Settings::SiteDefaultsController < ApplicationController
  def create
    @site_data = StaticData.find_by_name(params[:update_type].upcase)
    @site_data.value = params[:site_default][:new_value]

    if @site_data.save
      flash[:notice] = params[:update_type].humanize + " changed to '#{params[:site_default][:new_value]}'."
    else
      flash[:error] = "Failed to update #{params[:update_type].humanize.downcase} to '#{params[:site_default][:new_value]}'!"
    end

    redirect_to :action => "index"
  end
end
