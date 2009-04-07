// Loop through each row in the table and calculate the grades for that student.
function calculate() {
	$$('tr.calc').each(calcGrades);
}

// Given a row with student data, calculate the grade for that student
function calcGrades(row) {
  var final_score;
  var total_avail_points;
  var total_score;
  var grades;
  var total;
  var score;
  var points;

  // Make sure this row has a place to store the average
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

      // Did the user enter a number or a letter?     
      if (isNaN(parseFloat(grade_value))) {
      	// Look for any 'special' grades
      	switch(grade_value.toUpperCase()) {
      	  case 'M': // This is a missing grade and it is counted as a 0
      	    score = 0;
      	    break;
          case 'E': // This is an excused grade
            score = avail_points;
            break;
          default:  // This is an invalid grade
            grade.addClassName('grade-error');
            score = 0;
            break;
      	}
      } else {
        // This is a 'number' score
        score = parseFloat(grade_value);            
      }

    	// Make sure they didn't score more points than possible
    	if (score > avail_points || (score / avail_points) < .40) {
    		grade.addClassName('grade-warning');
    	} else {    	
    		grade.removeClassName('grade-warning');
	    }
		    
      // Keep a running total
      total_avail_points += avail_points;
      total_score += score;
    });

    // Show the result
    final_score.update(Math.round((total_score / total_avail_points)*100) + '%' )
  }
}

// Watch for keypresses on the form
$('grade_grid').observe('keyup', function(event){ 
  // Move to the next field when the user presses the ENTER key
	if (event.keyCode == Event.KEY_RETURN) {
	  // Get the current tabIndex and add 1 to it
    var nextIndex = Event.element(event).tabIndex + 1;

    // Find the next field in the tab order and SELECT its contents
    var element = $('grade_grid').down('input[tabindex="' + nextIndex + '"]')
    element.focus()
    element.select()
	}
});

// Dont allow the page to be submitted as a form.
$('grade_grid').observe('submit', function(event){
  event.stop();
});
