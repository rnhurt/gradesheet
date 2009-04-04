class UserSession < Authlogic::Session::Base 
  logout_on_timeout true # default is false
  after_create  :aauthorize
  after_destroy :deauthorize
  
private

  def aauthorize
    # If this user is an Admin authorize them for everything
#    if current_user.admin?
#    else
      case record[:type].downcase
        when 'teacher'
          controller.session[:authorize] = [
              ['Home', 'dashboard'],
              ['Courses', 'courses'], 
              ['Assignments', 'assignments'], 
              ['Grades', 'gradations'], 
              ['Reports', 'reports'], 
              ['My Settings', 'settings']]
        when 'student'
          controller.session[:authorize] = [
              ['Home', 'dashboard'],
              ['Grades', 'gradations'], 
              ['Reports', 'reports']] 
        else
          # unknown type of user
          controller.session[:authorize] = [['Nobody', 'dashboard']]
      end
#    end
  end  
      
  def deauthorize
    controller.session[:authorize] = [['Homey', 'dashboard']]
  end
end
