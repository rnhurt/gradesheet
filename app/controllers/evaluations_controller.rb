class EvaluationsController < ApplicationController
  before_filter :require_user
  append_before_filter :authorized?

  def show
    @course_term  = CourseTerm.find(params[:id])

    respond_to do |format|
      format.html { }
      format.js {
        # OPTIMIZE: Could this be moved to individual *.js.erb files??
        case params[:tab]
        when "assignments"
          @assignments  = Assignment.paginate_by_course_term_id(@course_term,
            :per_page => 6,
            :page     => params[:page],
            :order    => "due_date DESC, created_at ASC",
            :include  => :assignment_evaluations)
          @scalerange   = ScaleRange.find_all_by_grading_scale_id(@course_term.course.grading_scale_id)

          render :partial => "assignments"

        when "skills"
          @ctskills = @course_term.course_term_skills.paginate(
            :per_page => 5,
            :page     => params[:page])

          render :partial => "skills"

        when"comments"
          @quick_comments = Comment.quick.active
          
          render :partial => "comments"
        else
        end
      }
    end
  end

  def update
    respond_to do |format|
      # This data is only updated via AJAX
      format.html { render :nothing => true}
      
      format.js {
        # What are we updating, skills, grades or comments?
        if params[:skill]
          evaluation = SupportingSkillEvaluation.find_or_create_by_student_id_and_course_term_skill_id(
            params[:student], params[:skill], :include => [:students, :course_term_skills])

          # If the score is blank then delete the evaluation
          if params[:score].empty?
            SupportingSkillEvaluation.destroy(evaluation)
          else
            evaluation.score = params[:score]
          end
          
        elsif params[:assignment]
          evaluation = AssignmentEvaluation.find_or_create_by_student_id_and_assignment_id(
            params[:student], params[:assignment])

          # If the score is blank then delete the evaluation
          if params[:score].empty?
            AssignmentEvaluation.destroy(evaluation)
          else
            evaluation.points_earned = params[:score]
          end

        elsif params[:comment]
          evaluation = Comment.find_or_create_by_user_id_and_commentable_id(params[:student], params[:id])

          # If the comment is empty then delete the evaluation
          if params[:comment].empty?
            Comment.destroy(evaluation)
          else
            evaluation.content = params[:comment]
          end
        end

        # Save the record
        evaluation.save ? status = 200 : status = 444

        # Return the necessary info
        if params[:skill]
          render :nothing => true
        elsif params[:assignment]
          grade = CourseTerm.find(params[:id]).calculate_grade(params[:student])
          render :text => "#{grade[:letter]} (#{grade[:score].round}%)", :status => status
        elsif params[:comment]
          student = Student.find(params[:student])
          render :text => "YOU SUCK"
        end
      }
    end
  end

end
