
$(document).ready(function(){
  // perform basic validations before submission
  var fields = $("#courseTitle, #author, #course_metafile_short_description, #course_metafile_description, #moduleCount, #courseID");
  $("input:submit").click(function(){
    // checks for presence
    for(var i=0; i <= fields.length; i++){
      if($(fields[i]).val() == ""){
        event.preventDefault();
        $(fields[i]).css({'background-color': '#FFAC65'});
        alert("Please complete the highlighted items.");
        break;
      }
    }
    // strip newlines from descriptions
    var descriptions = $("#course_metafile_description, #course_metafile_short_description")
    for(var i=0; i <= descriptions.length; i++){
      var currentDescription = $(descriptions[i]).val();
      $(descriptions[i]).val((currentDescription).replace(/\n/g," "));
    }
  });

  // clear validations error formatting when any field is clicked
  $(fields).click(function(){
    $(this).css({"background-color": "#FFFFFF"})
  });
});
