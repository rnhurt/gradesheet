class UserSession < Authlogic::Session::Base 
  logout_on_timeout true # default is false
  consecutive_failed_logins_limit 10  # only let them try to log in 10 times
  failed_login_ban_for 30.minutes     # and keep them out for 30 minutes
  
  after_create  :authorize
  after_destroy :deauthorize
  
private

  def authorize
    # If this user is an Admin authorize them for everything
    if record.is_admin?
          controller.session[:authorize] = [
              ['Home', 'dashboard'],
              ['Users', 'users'], 
                ['', 'students'], 
                ['', 'teachers'], 
                ['', 'teacher_assistants'], 
              ['Courses', 'courses'], 
              ['Assignments', 'assignments'], 
              ['Grades', 'gradations'], 
              ['Reports', 'reports'],
              ['Site Settings', 'settings'],
                ['', 'assignment_categories'],
                ['', 'grading_scales'],
                ['', 'imports'],
                ['', 'sites'],
                ['', 'terms'],
              ]
    else
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
              ['My Grades', 'grades']] 
        else
          # unknown type of user
          controller.session[:authorize] = [['Home', 'dashboard']]
      end
    end
  end  
      
  def deauthorize
    controller.session[:authorize] = [['Home', 'dashboard']]
  end
end
