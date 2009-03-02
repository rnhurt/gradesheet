// Loop through each row in the table and calculate the grades for that student.
function calculate() {
	$$('tr.calc').each(calcGrades);
}

// Given a row with student data, calculate the grade for that student
function calcGrades(row) {
  var totalscore;
  var grades;
  var total;
  var count;
  var score;
  var points;

  // Make sure this row has a place to store the average
  totalscore = row.select('td.score')[0];
  if (totalscore) {
    // It does, get the relevant grades
    grades = row.select('input[name^=grade]');

    // Compute the score, allowing for empty/non-numeric cells
    total_percentage = 0.0;
    count = 0.0;
    grades.each(function(grade) {
      // Variables
     	avail_points  = parseFloat(grade.readAttribute('points')); // How many points is this assignment worth?
    	grade_value   = grade.getValue();                          // What grade did the user enter?
    	skip_grade    = false;                                     // Should we skip this grade?

      // Did the user enter a number or a letter?     
      if (isNaN(parseFloat(grade_value))) {
      	// Look for any 'special' grades
      	switch(grade_value.toUpperCase()) {
      	  case 'M': // This is a missing grade and it is counted as a 0
      	    score = 0;
      	    break;
          case 'E': // This is an excused grade
            skip_grade = true;
            break;
          default:  // This is an invalid grade
            grade.addClassName('grade-error');
            skip_grade = true;
            score = 0;
            break;
      	}
      } else {
        // This is a 'number' score
        score = parseFloat(grade_value);            
      }

      // Only average in grades that are valid    	
    	if (!skip_grade) {
        grade.removeClassName('grade-error');
        
      	// Make sure they didn't score more points than possible
      	if (score > avail_points) {
      		grade.addClassName('grade-warning');
      	} else {    	
      		grade.removeClassName('grade-warning');
		    }
		    
        // Total up the percentage
        total_percentage += score / avail_points;
        ++count;
  		} // skip_grade
    });

    // Show the result
    if (count > 0) {
    	original = (total_percentage / count)*100
      totalscore.update(Math.round(original*100)/100 + '%');
    } else {
      totalscore.update('n/a');
    }
  }
}


//Event.observe('grade_grid', 'keyup', function(event){ 
$('grade_grid').observe('keyup', function(event){ 

	if (event.keyCode == Event.KEY_RETURN) {
	  Event.keyCode = Event.KEY_TAB;
//	  Event.stop();
	}
		
});

