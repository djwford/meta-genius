Opentip.defaultStyle = "dark";

$(document).ready(function(){
  // enable chosen
  $(".chosen-select").chosen({width: "100%"});

  // perform basic validations before submission
  // var fields = $("#courseTitle, #author, #course_metafile_short_description, #course_metafile_description, #moduleCount, #courseID");
  // add class 'required' to first three chosen fields...sigh
    // theoretically, there could be a course for which no current tags apply.
    // so i'll mark audience, topics, and tools as required but won't force them
    // var chosen_search_fields = $('.search-field').slice(0,2);
    //
    // for(i = 0; i < chosen_search_fields.length; i++){
    //   $(chosen_search_fields[i]).find('input').addClass('required');
    // }

  var fields = $(".required");
  $("input:submit").click(function(){
    // checks for presence
    for(var i=0; i < fields.length; i++){
      if($(fields[i]).val() == "" || $(fields[i]).val() == "Select topics tags" || $(fields[i]).val() == "Select tools tags"){
        event.preventDefault();
        $(fields[i]).css({'background-color': '#FFAC65'});
        alert("Please complete the highlighted items.");
        break;
      }
    }
    // strip newlines from descriptions
    var descriptions = $("#course_metafile_description, #course_metafile_short_description")
    for(var i=0; i < descriptions.length; i++){
      var currentDescription = $(descriptions[i]).val();
      $(descriptions[i]).val((currentDescription).replace(/\n/g," "));
    }
  });

  // clear validations error formatting when any field is clicked
  $(fields).click(function(){
    $(this).css({"background-color": "#FFFFFF"})
  });

  // suggested tags hide/reveal
  $(".suggested_input").hide();
  $("#suggest_button").click(function(){
    var hidden_div = $(".suggested_input:hidden:first");
    $(hidden_div).slideToggle("fast");
    $(hidden_div).find("input:text:first").focus();
  });
  $(".close_button").click(function(){
    $(this).closest(".suggested_input").slideToggle('slow');
    $(this).closest('.suggested_input').find("input:text").val('');
    $(this).closest('.suggested_input').find(".tag_type_input").val('');

  });
});
