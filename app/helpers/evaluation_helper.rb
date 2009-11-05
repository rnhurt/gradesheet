module EvaluationHelper

  # Build the header for the skill evaluation partial
  def skills_header
    body = "<tr><th width='100'>Student Name</th>"

    if @ctskills.size == 0
      body << '<th>No Skills Found</th>'
    else
      @ctskills.each do |skill|
        body << "<th width='60' class='skill' id='#{skill.id}'>"
        body << "<div class='skill-name'>#{word_wrap(skill.supporting_skill.description, :line_width => 10).gsub(/\n/,'<br />')}</div>"
        body << "</th>"
      end
    end

    body += '</tr>'
  end

  # Build the body for the skills evaluation partial
  def skills_body
    students = @course_term.students.sort_by {|a| a.last_name }
    body = ''

    if students.size == 0
      body << "<tr><td>No Students Found</td></tr>"
    else
      # Process each student
      students.each_with_index do |student, index|
        #  Set up the row for this student
        body << "<tr class='calc #{cycle('odd','even')}' id='#{student.id}'>"
        body << "<td width='100' id='#{student.id}'>#{student.full_name}</td>"
        a_counter = index + 1

        # Build the table and form entries for each skill for this student
        @ctskills.each do |ctskill|
          body << "<td class='skills' width='60'>"
        
          body += text_field_tag 'score', ctskill.score(student.id),
            :name     => 'skill',
            :id       => [:s => student.id, :a => ctskill.id],
            :tabindex	=> a_counter,
            :size     => '5',
            :onchange => remote_function( :url => {:action => "update"}, :method => "put",
            :with     => "'student=#{student.id}&skill=#{ctskill.id}&score=' + value",
            :loading  => "Element.show('spinner')",
            :complete => "Element.hide('spinner')")

          body << "</td>"
          a_counter += students.size
        end
      
        body << "</tr>"
      end
    end
    return body
  end

  # Build the header for the grade evaluation partial
  def grades_header
    body = "<tr><th width='20'>Score</th><th width='60'>Student Name</th>"

    if @assignments.size == 0 then
      body << '<th>No Assignments Found</th>'
    else
      @assignments.each do |assignment|
        body << "<th width='17' class='grade' id='#{assignment.id}'>"
        body << "<div class='assign-name'>"
        body << "<a href='/assignments/#{assignment.id}/edit'>#{word_wrap(assignment.name, :line_width => 10).gsub(/\n/,'<br />')}</a>"
        body << "</div><div class='assign-points'>"
        body += link_to_function assignment.possible_points,
          "$$('[id*=a#{assignment.id}]').each(function(g) { g.value = #{assignment.possible_points}; g.onchange(); });"
        body << " pts</div>"
        body << "<div class='assign-date'>#{h assignment.due_date ? assignment.due_date.to_s(:due_date) : '.'}</div>"
        body << '</th>'
      end
    end
    body << "</tr>"
  end

  # Build the body for the grade evaluation partial
  def grades_body
    students = @course_term.students.sort_by {|a| a.last_name }

    body = ''
    if students.size == 0 then
      body << "<tr><td>No Students Found</td></tr>"
    else
      students.each_with_index do |student, index|
        # Calculate the students grade.
        # OPTIMIZE: I think this is an expensive operation
        grade = @course_term.calculate_grade(student.id)

        # Set up the row for this student
        body << "<tr class='calc #{cycle('odd','even')}' id='#{student.id}'>"
        body << "<td id='score#{student.id}' class='score' width='20'>"
        body << "#{grade[:letter]} (#{grade[:score].round}%)</td>"
        body << "<td id=#{student.id} width='60'>#{student.full_name}</td>"
        a_counter = index + 1

        # Build the cells to hold each grade
        @assignments.each do |assignment|
          body << "<td width='17' class='grades'>"
          found = student.assignment_evaluations.select{|a| a.assignment_id == assignment.id}.first

          # This is being built by hand because it is a tight loop with performance problems
          body << "<input type='text' value=\'#{found ? found.points_earned : ''}\' "
          body << " tabindex='#{a_counter}' size='5'"
          body << " points='#{assignment.possible_points}'"
          body << " name='grade' id='#{[:s => student.id, :a => assignment.id]}'"

          # Build the complex remote_function by hand
          body += <<DOC
onchange="new Ajax.Updater('score#{student.id}', '/evaluations/#{@course_term.id}',
 {asynchronous:true, evalScripts:true, method:'put', onComplete:function(request){status('complete', #{student.id}, #{assignment.id})},
 onFailure:function(request){status('failure', #{student.id}, #{assignment.id})},
 onLoading:function(request){status('loading', #{student.id}, #{assignment.id})},
 onSuccess:function(request){status('success', #{student.id}, #{assignment.id})},
 parameters:'student=#{student.id}&amp;assignment=#{assignment.id}&amp;score=' + value + '&amp;authenticity_token=' + encodeURIComponent('#{form_authenticity_token}')}
)"

DOC
          body << ' /> </td>'

          #                    FIXME: Remove this when we are done optimizing
          #                    body += text_field_tag 'score', found ? found.points_earned : '',
          #                      :points   => assignment.possible_points,
          #                      :name     => 'grade',
          #                      :id       => [:s => student.id, :a => assignment.id],
          #                      :tabindex => a_counter,
          #                      :size     => '5',
          #                      :onchange => remote_function( :url => {:action => "update"}, :method => "put",
          #                      :with     => "'student=#{student.id}&assignment=#{assignment.id}&score=' + value",
          #                      :update   => "score#{student.id}",
          #                      :loading  => "status('loading', #{student.id}, #{assignment.id})",
          #                      :failure  => "status('failure', #{student.id}, #{assignment.id})",
          #                      :success  => "status('success', #{student.id}, #{assignment.id})",
          #                      :complete => "status('complete', #{student.id}, #{assignment.id})")
          
          a_counter += students.size
        end

        # Clean up the HTML if no @assignments are found in the DB
        body << "<td width='30' class='grades'>&nbsp;</td>" if @assignments.size < 1

        body << '</tr>'

      end
    end

    return body
  end
  
end