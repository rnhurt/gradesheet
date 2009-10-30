module EvaluationHelper

  # Build the header for the skill evaluation partial
  def skills_header
    body = "<tr><th width='83'>Student Name</th>"

    if @course_term.supporting_skills.size == 0
      body << '<th>No Skills Found</th>'
    else
      @course_term.supporting_skills.each do |skill|
        body << "<th width='50' class='skill' id='#{skill.id}'>"
        body << "<div class='skill-name'>#{skill.description}</div>"
        body << "</th>"
      end
    end

    body += '</tr>'
  end

  # Build the body for the skills evaluation partial
  def skills_body
    body = ''

    if @students.size == 0
      body << "<tr><td>No Students Found</td></tr>"
    else
      # Process each student
      @students.each_with_index do |student, index|
        #  Set up the row for this student
        body << "<tr class='calc #{cycle('odd','even')}' id='#{student.id}'>"
        body += content_tag :td, student.full_name, :id => student.id
        a_counter = index + 1

        # Build the table and form entries for each skill for this student
        @course_term.course_term_skills.each do |ctskill|
          body << "<td class = 'skills'>"
        
          body += text_field_tag 'score', ctskill.score(student.id),
            :name		=> 'skill',
            :id			=> [:s => student.id, :a => ctskill.id],
            :tabindex	=> a_counter,
            :onchange => remote_function( :url => {:action => "update"}, :method => "put",
            :with   => "'student=#{student.id}&skill=#{ctskill.id}&score=' + value",
            :loading => "Element.show('spinner')",
            :complete => "Element.hide('spinner')"),
            :size		=> '5'

          body << "</td>"
          a_counter += @students.size
        end
      
        body << "</tr>"
      end
    end
    return body
  end

  # Build the header for the grade evaluation partial
  def grades_header
    body = "<tr><th width='10'>Score</th><th width='30'>Student Name</th>"

    if @assignments.size == 0 then
      body << '<th>No Assignments Found</th>'
    else
      @assignments.each do |assignment|
        body << "<th width='17' class='grade nosort' id='#{assignment.id}'>"
        body << "<div class='assign-name'><a href='/assignments/#{assignment.id}/edit'>#{assignment.name}</a></div>"
        body << "<div class='assign-points'>"
        body += link_to_function assignment.possible_points,
          "$$('[id*=a#{assignment.id}]').each(function(g) { g.value = #{assignment.possible_points}; g.onchange(); });"
        body << " pts</div>"
        body << "<div class='assign-date'>#{h assignment.due_date ? assignment.due_date.to_s(:due_date) : '.'}</div>"
        body << '</th>'
      end
    end
    body << '</tr>'
  end

  # Build the body for the grade evaluation partial
  def grades_body
    body = ''
    if @students.size == 0 then
      body << "<tr><td>No Students Found</td></tr>"
    else
      @students.each_with_index do |student, index|
        # Calculate the students grade.
        # OPTIMIZE: This is an *extremely* expensive operation!
        grade = @course_term.calculate_grade(student.id)
#debugger

        # Set up the row for this student
        body << "<tr class='calc #{cycle('odd','even')}' id='#{student.id}'>"
        body << "<td id='score#{student.id}' class='score' width='60'>"
        body << "#{grade[:letter]} (#{grade[:score].round}%)</td>"
        body << "<td id=#{student.id} width='100'>#{student.full_name}</td>"
        a_counter = index + 1

        # Build the cells to hold each grade
        @assignments.each do |assignment|
          body << "<td class='grades'>"
          found = student.assignment_evaluations.select{|a| a.assignment_id == assignment.id}.first

          body += text_field_tag 'score', found ? found.points_earned : '',
            :points   => assignment.possible_points,
            :name     => 'grade',
            :id       => [:s => student.id, :a => assignment.id],
            :tabindex => a_counter,
            :onchange => remote_function( :url => {:action => "update"}, :method => "put",
            :with     => "'student=#{student.id}&assignment=#{assignment.id}&score=' + value",
            :update   => "score#{student.id}",
            :loading  => "status('loading', #{student.id}, #{assignment.id})",
            :failure  => "status('failure', #{student.id}, #{assignment.id})",
            :success  => "status('success', #{student.id}, #{assignment.id})",
            :complete => "status('complete', #{student.id}, #{assignment.id})"),
            :size     => '5'

          body << '</td>'
          
          a_counter += @students.size
        end

        # Clean up the HTML if no @assignments are found in the DB
        body << "<td class='grades'>&nbsp;</td>" if @assignments.size < 1

        body << '</tr>'

      end
    end

    return body
  end
  
end
