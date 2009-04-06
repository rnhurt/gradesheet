class UserSession < Authlogic::Session::Base 
  logout_on_timeout true # default is false
  after_create  :authorize
  after_destroy :deauthorize
  
private

  def authorize
    # If this user is an Admin authorize them for everything
#    if current_user.admin?
#          controller.session[:authorize] = [
#              ['Home', 'dashboard'],
#              ['Courses', 'courses'], 
#              ['Assignments', 'assignments'], 
#              ['Grades', 'gradations'], 
#              ['Reports', 'reports'],
#              ['Site Settings', 'settings'],
#              ['', 'sites'],
#              ]
#    else
      case record[:type].downcase
        when 'teacher'
          controller.session[:authorize] = [
              ['Home', 'dashboard'],
              ['Courses', 'courses'], 
              ['Assignments', 'assignments'], 
              ['Grades', 'gradations'], 
              ['Reports', 'reports']]
        when 'student'
          controller.session[:authorize] = [
              ['Home', 'dashboard'],
              ['Grades', 'gradations'], 
              ['Reports', 'reports']] 
        else
          # unknown type of user
          controller.session[:authorize] = [['Home', 'dashboard']]
      end
#    end
  end  
      
  def deauthorize
    controller.session[:authorize] = [['Home', 'dashboard']]
  end
end
