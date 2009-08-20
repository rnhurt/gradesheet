class Settings::SiteDefaultsController < ApplicationController
  def create
    case params[:update_type]
    when "site_name"
      StaticData.site_name = params[:site_default][:site_name]
      flash[:notice] = "Site name changed to '#{params[:site_default][:site_name]}'"
    when "site_tag"
      StaticData.tag_line = params[:site_default][:site_tag]
      flash[:notice] = "Site tag line changed to '#{params[:site_default][:site_tag]}'"
    else
      flash[:error] = "Unknown option.  No change made."
    end
    
    redirect_to :action => "index"
  end
end
