module GradeHelper

  def my_grades_table
    body = ""
    body = <<-eos
      <table class="master sortable">
        <thead><tr>
        <th>Course</th>
        <th>Term</th>
        <th>Teacher</th>
        <th>Grade</th>
      </tr></thead>
      <body>
    eos

    @courses.each do |course|
      body += %{
        <tr class="#{cycle('odd','even')}">
          <td>#{course.name}</td>
          <td>#{course.terms.current[0] ? course.terms.current[0].name : 'n/a'}</td>
          <td>#{course.teacher.full_name}</td>
          <td>#{course.terms.current[0] ? 'score goes here' : 'n/a'}</td>
        </tr>
      }
    end

    body += "</body></table>"
    
    return body
  end

end
