// Control the movement between fields in the form
$$('form').each(function(f) {
  f.observe('keyup', function(event){
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
});

// Don't allow the page to be submitted as a form.
$$('form').each(function(f) {
  f.observe("submit", function(event){
    event.stop();
  });
});

// Fix the pagination links
$$('.pagination').each(function(m){
  name = m.getAttribute('name');
  
  m.select('a').each(function(a) {
    a.observe("click", function(e){
      new Ajax.Updater(name, a.href,
      {
        asynchronous:true,
        evalScripts:true,
        method:'get',
        onComplete:function(request){
          $('loading').hide();
        },
        onLoading:function(request){
          show_message(name)
        }
      });
      e.stop();
    });
  })
});

