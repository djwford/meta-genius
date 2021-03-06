Opentip.defaultStyle = "dark";
function setHREF(){
  var clips = $('.clip_container');
  var courseTitle = $("#courseID").val().trim();
  courseTitle = courseTitle.replace(/\s/g,"-").toLowerCase()
  var moduleNumber = $("#moduleNumber").val();
  for(var i=0; i <= clips.length; i++){
    var target = $(clips[i]).find(".clip_href");
    if((i + 1) < 10){
      var clipNumber = ("0" + (i + 1))
    }
    else { clipNumber = (i + 1)}
    var href = (courseTitle + "-m" + moduleNumber + "-" + clipNumber + ".mp4");
    $(target).val(href);
    console.log(href);
  }
}

$(document).ready(function(){
  // perform basic validations before submission
  var fields = $("#courseTitle, #moduleNumber, #author, #metafile_title, #module_metafile_description, #courseID");
  $("input:submit").click(function(){
    // checks for presence
    for(var i=0; i <= fields.length; i++){
      if($(fields[i]).val() == ""){
        event.preventDefault();
        $(fields[i]).css({'background-color' : '#FFAC65'});
        alert("Please complete the highlighted items.");
        break;
      }
    }
    // strip newlines from description
    var currentDescription = $("#module_metafile_description").val();
    $("#module_metafile_description").val(currentDescription.replace(/\n/,""));
    // strip newlines from descriptions
    var currentDescription = $("#module_metafile_description").val();
    $("#module_metafile_description").val((currentDescription).replace(/\n/g," "));
  });
  // when the course title is changed, set all HREF inputs
  $("#courseTitle").blur(function(){
    setHREF();
  });
  $("#moduleNumber").blur(function(){
    setHREF();
  })

  $("#clear").click(function(){
    event.preventDefault();
    $("#courseTitle, #moduleNumber, #courseID, #author, #metafile_title, #metafile_description, .clip_title").val("");
  });
  $(fields).click(function(){
    $(this).css({"background-color": "#FFFFFF"})
  });
});



