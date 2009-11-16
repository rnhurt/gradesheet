module EvaluationHelper

  # Build the header for the skill evaluation partial
  def skills_header
    body    = "<tr><th width='100'>Student Name</th>"

    # Build the <option> elements
    options = '<option> </option>'
    SupportingSkillCode.all.each do |option|
      options << "<option value='#{option.code}'>#{option.code}</option>"
    end

    if @ctskills.size == 0
      body << '<th>No Skills Found</th>'
    else
      @ctskills.each do |skill|
        body << "<th width='60' class='skill' id='#{skill.id}'>"
        body << "<div class='skill-name'>#{word_wrap(skill.supporting_skill.description, :line_width => 10).gsub(/\n/,'<br />')}</div>"

        # Build the <select> element by hand
        body += <<END
<select onchange="$$('[id*=k#{skill.id}]').each(function(g) { g.value = value; g.onchange(); });">
END
        body << "#{options}</select></th>"
      end
    end

    body += '</tr>'
  end

  # Build the body for the skills evaluation partial
  def skills_body
    students  = @course_term.students.sort_by {|a| a.last_name }
    options   = SupportingSkillCode.all
    body = ''

    if students.size == 0
      body << "<tr><td>No Students Found</td></tr>"
    else
      # Process each student
      students.each_with_index do |student, index|
        #  Set up the row for this student
        body << "<tr class='calc #{cycle('odd','even')}' id='skill#{student.id}'>"
        body << "<td width='100' id='#{student.id}'>#{student.full_name}</td>"
        a_counter = index + 1

        # Build the table and form entries for each skill for this student
        @ctskills.each do |ctskill|
          body << "<td class='skills' width='60'>"

          # Build the complex remote_function by hand
          body << "<select name='skill' id='s#{student.id}k#{ctskill.id}' "
          body += <<END
onchange="new Ajax.Request('/evaluations/#{@course_term.id}',
 {asynchronous:true, evalScripts:true, method:'put', onComplete:function(){update_skill_status('complete', #{student.id}, #{ctskill.id})},
 onFailure:function(){update_skill_status('failure', #{student.id}, #{ctskill.id})},
 onLoading:function(){update_skill_status('loading', #{student.id}, #{ctskill.id})},
 onSuccess:function(){update_skill_status('success', #{student.id}, #{ctskill.id})},
 parameters:'student=#{student.id}&amp;skill=#{ctskill.id}&amp;score=' + value + '&amp;authenticity_token=' + encodeURIComponent('#{form_authenticity_token}')})"
END
          score = ctskill.score(student.id)
          body << '<option> </option>'
          options.each do |option|
            body << '<option '
            body << 'SELECTED ' if option.code == score
            body << "value='#{option.code}'>#{option.code}</option>"
          end
          body << '</select></td>'

          a_counter += students.size
        end
      
        body << '</tr>'
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
          body << " name='grade' id='s#{student.id}a#{assignment.id}'"

          # Build the complex remote_function by hand
          body += <<END
onchange="new Ajax.Updater('score#{student.id}', '/evaluations/#{@course_term.id}',
 {asynchronous:true, evalScripts:true, method:'put', onComplete:function(request){update_grade_status('complete', #{student.id}, #{assignment.id})},
 onFailure:function(request){update_grade_status('failure', #{student.id}, #{assignment.id})},
 onLoading:function(request){update_grade_status('loading', #{student.id}, #{assignment.id})},
 onSuccess:function(request){update_grade_status('success', #{student.id}, #{assignment.id})},
 parameters:'student=#{student.id}&amp;assignment=#{assignment.id}&amp;score=' + value + '&amp;authenticity_token=' + encodeURIComponent('#{form_authenticity_token}')})"
END
          body << ' /> </td>'

          a_counter += students.size
        end

        # Clean up the HTML if no @assignments are found in the DB
        body << "<td width='30' class='grades'>&nbsp;</td>" if @assignments.size < 1

        body << '</tr>'
      end
    end

    return body
  end

  # Build the header for the skill evaluation partial
  def comments_body
    students = @course_term.students.sort_by {|a| a.last_name }

    body = ''
    if students.size == 0 then
      body << "<tr><td>No Students Found</td></tr>"
    else
      students.each_with_index do |student, index|
        comment = Comment.find_by_user_id_and_commentable_id(student.id, @course_term.id.to_s)

        body << "<tr class='calc #{cycle('odd','even')}' id='comment#{student.id}'>"
        body << "<td width='120'>#{student.full_name}</td>"
        body << "<td><input id='c#{student.id}' type='text' value=\""
        body += h comment.content if comment
        body << "\" tabindex=#{index} size='50' "

        # Build the remote_function by hand
        body += <<END
onchange="new Ajax.Request('/evaluations/#{@course_term.id}',
 {asynchronous:true, evalScripts:true, method:'put', onComplete:function(request){update_comment_status('complete', #{student.id})},
 onFailure:function(request){update_comment_status('failure', #{student.id})},
 onLoading:function(request){update_comment_status('loading', #{student.id})},
 onSuccess:function(request){update_comment_status('success', #{student.id})},
 parameters:'student=#{student.id}&amp;comment=' + encodeURIComponent(value) + '&amp;authenticity_token=' + encodeURIComponent('#{form_authenticity_token}')})"
END
        body << ' /> </td>'


        body += drop_receiving_element("comment#{student.id}",
          :onDrop => "function(draggable_element, droppable_element, event) {
                         new_comment = draggable_element.innerHTML.gsub('%fn', droppable_element.childNodes[0].childNodes[0].textContent.split(' ',1));
                         droppable_element.childNodes[1].childNodes[0].setValue(new_comment);
                         droppable_element.childNodes[1].childNodes[0].simulate('change');}",
          :hoverclass => 'current')
       
        # Build the drop_receiving_element javascript by hand
        # OPTIMIZE: This code doesn't quite work for some reason...
        #        body << "<script type='text/javascript'>//<![CDATA[ "
        #        body << "Droppables.add('comment#{student.id}', {hoverclass:'current', onDrop:function(draggable_element, droppable_element, event) {"
        #        body << " new_comment = draggable_element.innerHTML.gsub('%fn', droppable_element.childNodes[0].childNodes[0].textContent.split(' ',1));"
        #        body << " droppable_element.childNodes[1].childNodes[0].setValue(new_comment);"
        #        body << " droppable_element.childNodes[1].childNodes[0].simulate('change');}}) "
        #        body << '//]]></script>'
        body << '</tr>'
      end
    end

    return body
  end

  def quick_comments_body
    body = ''

    @quick_comments.each do |comment|
      body << "<tr class='#{cycle('odd','even')}'>"
      body << "<td><div id='qc#{comment.id}'>#{comment.content}</div></td>"

      body += draggable_element("qc#{comment.id}",
        :revert => true, :ghosting => true, :scroll => :window,
        :reverteffect => "function(element, top_offset, left_offset) { new Effect.MoveBy(element, -top_offset, -left_offset, {duration:0});}")
      body << '</tr>'
    end

    return body
  end
end
