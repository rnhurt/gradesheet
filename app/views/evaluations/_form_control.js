window.processPage = function(mode) {
  if (mode == 'assignments') {
    console.log('Processing assignments...')
    controlKeyboard('grade_grid');
    restrictSubmit('grade_grid');
    rewritePagination('assignments_pagination');
    
  } else if (mode == 'skills') {
    console.log('Processing skills...')
    controlKeyboard('skills_grid');
    restrictSubmit('skills_grid');
    rewritePagination('skills_pagination');
  } else {
    alert("WARNING - mode not defined: " + mode);
  }

  $('loading').hide();
}

window.controlKeyboard = function(form){
  // Control the movement between fields in the form
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

window.restrictSubmit = function(form){
  // Don't allow the page to be submitted as a form.
  $(form).observe("submit", function(event){
    event.stop();
  });
}

window.rewritePagination = function(element){
  // Fix the pagination links
  name = $(element).readAttribute('name');
  console.log("rewritePagination name = " + name);
  
  $(element).select('a').each(function(a) {
    console.log("rewriting " + a + " from " + element);

    // Clean up old observers
    a.stopObserving();

    // Add a new 'click' observer
    a.observe("click", function(e){
      new Ajax.Updater(name, a.href,  {
        asynchronous:true,
        evalScripts:true,
        method:'get',
        onComplete:function(request){
        //processPage(name);
        },
        onLoading:function(request){ 
          show_message(name)
        }
      });
      e.stop();   // Stop the link from being followed
    });
  });
}