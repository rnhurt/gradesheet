// Get everything ready for a particular page type (mode)
window.processPage = function(mode) {
  if (mode == 'assignments') {
    controlKeyboard('grade_grid');
    restrictSubmit('grade_grid');
    $('grade_grid').getInputs().each(cell_status);
    
  } else if (mode == 'skills') {
    controlKeyboard('skills_grid');
    restrictSubmit('skills_grid');

  } else if (mode == 'comments'){
  } else {
    alert("WARNING - mode not defined: " + mode);
  }

  $('loading').hide();
}

// Control the movement between fields in the form
window.controlKeyboard = function(form){
  $(form).observe('keyup', function(event){
    // Move to the next field when the user presses the ENTER key
    switch (event.keyCode) {
      case Event.KEY_DOWN:
      case Event.KEY_RETURN:
        // Get the current tabIndex and add 1 to it
        var nextIndex = Event.element(event).tabIndex + 1;

        // Find the next field in the tab order and SELECT its contents
        var element = this.down('input[tabindex="' + nextIndex + '"]')
        if (element) {
          element.focus();
          element.select();
        }
        break;
        
      case Event.KEY_UP:
        // Get the current tabIndex and add 1 to it
        var prevIndex = Event.element(event).tabIndex - 1;

        // Find the next field in the tab order and SELECT its contents
        var element = this.down('input[tabindex="' + prevIndex + '"]')
        if (element) {
          element.focus();
          element.select();
        }
        break;
    }
  });
}

// Don't allow the page to be submitted as a form, only update with AJAX
window.restrictSubmit = function(form){
  $(form).observe("submit", function(event){
    event.stop();
  });
}
