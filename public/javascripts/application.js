// Begin processing commands after the page loads
document.observe("dom:loaded", function() {
  setFocus();
});

function setFocus() {
  // Set the focus on the last input tag with a class of "focus"
  $$("input[class*='focus']").each(function(i) {
    i.focus();
    i.select();
  });
}