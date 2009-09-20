// Loop through each row in the table and calculate the grades for that student.
function calculate() {
  // OPTIMIZE - only calculate the rows that have changed.
  $$('tr.calc').each(calcGrades);
}

// Given a row with student data, calculate the grade for that student
function calcGrades(row) {
  var final_score;
  var total_avail_points;
  var total_score;
  var grades;
  var score;

  // Make sure this row has a place to store the score
  final_score = row.select('td.score')[0];

  if (final_score) {
    // It does, get the relevant grades
    grades = row.select('input[name^=grade]');

    // Compute the score, allowing for empty/non-numeric cells
    total_score = 0.0;
    total_avail_points = 0.0;
    grades.each(function(grade) {
      // Variables
      avail_points  = parseFloat(grade.readAttribute('points')); // How many points is this assignment worth?
      grade_value   = grade.getValue();                          // What grade did the user enter?

      // Reset any CSS names
      grade.removeClassName('grade-warning');
      grade.removeClassName('grade-error');
      grade.removeClassName('grade-empty');

      // Did the user enter a number or a letter?
      score = parseFloat(grade_value);
      if (isNaN(score)) {
        // Its not a number so look for any 'special' grades
        switch(grade_value.toUpperCase()) {
          case 'M': // This is a missing grade and it is counted as a 0
            grade.addClassName('grade-warning');
            score = 0;
            break;
          case 'E': // This is an excused grade and it is ignored
            grade.addClassName('grade-warning');
            score = null;
            break;
          case '': // This is a blank grade
            grade.addClassName('grade-empty');
            score = null;
            break;
          default:  // This is an invalid grade
            grade.addClassName('grade-error');
            score = 0;
        }
      }

      // Don't count blank grades
      if (score != null) {
        // Make sure they didn't score more points than possible
        if (score > avail_points || (score / avail_points) < .40) {
          grade.addClassName('grade-warning');
        }
		    
        // Keep a running total
        total_avail_points += avail_points;
        total_score += score;
      }
    });

    // Compute the score for this assignment
    if (total_avail_points > 0) {
      var computed_score = Math.round((total_score / total_avail_points)*100);
    } else {
      var computed_score = 100 + total_score;
    }
      
    // Display the result
    if (isNaN(parseFloat(computed_score))) {
      final_score.update( 'n/a' );
    } else {
      final_score.update( calcLetterGrade(computed_score) + ' (' + computed_score + '%)' );
    }
  }
}