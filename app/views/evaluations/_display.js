// Keep the user informed of what is going on in the background.
window.update_grade_status = function(mode, student_id, assignment_id) {
  // Define the objects we need
  var grade = $('s' + student_id + 'a' + assignment_id)   // Get the "grade" object
  var score = $('score' + student_id)                     // Get the "score" object

  // Reset any CSS names
  grade.removeClassName('grade-warning');
  grade.removeClassName('grade-error');
  grade.removeClassName('grade-empty');

  switch (mode) {
    case('loading'):
      // Begin the update process...
      score.addClassName('grade-updating');

      break;
    case('success'):
      // Data was saved successfully
      grade.removeClassName('grade-error');

      break;
    case('failure'):
      // Data did not save successfully
      grade.addClassName('grade-error');

      break;
    case('complete'):
      // Update is complete
      score.removeClassName('grade-updating');
      cell_status(grade)
      
      break;
  }
}

window.update_skill_status = function(mode, student_id, skill_id) {
  // Define the objects we need
  var skill = $('s' + student_id + 'a' + skill_id)   // Get the "skill" object

  // Reset any CSS names
  skill.removeClassName('grade-warning');
  skill.removeClassName('grade-error');
  skill.removeClassName('grade-empty');

  switch (mode) {
    case('loading'):
      // Begin the update process...
      skill.addClassName('grade-updating');

      break;
    case('success'):
      // Data was saved successfully
      skill.removeClassName('grade-error');

      break;
    case('failure'):
      // Data did not save successfully
      skill.addClassName('grade-error');

      break;
    case('complete'):
      // Update is complete
      skill.removeClassName('grade-updating');

      break;
  }

}

// Change the look of a cell depending on the value entered by the user
window.cell_status = function(e){
  var avail_points  = parseFloat(e.readAttribute('points'));  // How many points is this assignment worth?
  var grade_value   = e.getValue();                           // What grade did the user enter?

  // Did the user enter a number or a letter?
  score = parseFloat(grade_value);
  if (isNaN(score)) {
    // Its not a number so look for any 'special' grades
    switch(grade_value.toUpperCase()) {
      case 'M': // This is a missing grade and it is counted as a 0
        e.addClassName('grade-warning');

        break;
      case 'E': // This is an excused grade and it is ignored
        e.addClassName('grade-warning');

        break;
      case '': // This is a blank grade
        e.addClassName('grade-empty');

        break;
      default:  // This is an invalid grade
        e.addClassName('grade-error');
    }
  } else {
    // Warn the user about any out of the ordinary grades (too large/small)
    if (score > avail_points || (score / avail_points) < .40) {
      e.addClassName('grade-warning');
    }

  }
}
