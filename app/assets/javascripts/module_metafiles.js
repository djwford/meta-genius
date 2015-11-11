
function setHREF(){
  var clips = $('.clip_container');
  var courseTitle = $("#courseTitle").val().trim();
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
  $(".clip_container").hide();

  // perform basic validations before submission
  $("input:submit").click(function(){

    var fields = $("#courseTitle, #moduleNumber, #author, #metafile_title, #metafile_description");
    for(var i=0; i <= fields.length; i++){
      if($(fields[i]).val() == ""){
        event.preventDefault();
        $(fields[i]).css({'background-color' : '#FFAC65'});
        alert("Please complete the highlighted items.");
        break;
      }
    }
  });

  // add clips button
  $("#add_clips").click(function(){
    var clips_count = parseInt($("#clips_count").val());
    var hidden_clips = $(".clip_container").filter(":hidden");

    //if there are enough clips available, unhide
    if(hidden_clips.length >= clips_count)
    {
      for(i=0; i < clips_count; i++)
      {
        $(hidden_clips[i]).show();
      }
    }
  });

  // remove clips button
  $(".remove_button").click(function(){
    event.preventDefault();
    var clipContainer = $(this).closest(".clip_container");
    $(clipContainer).hide();
    $(clipContainer).find(".clip_title").val("");
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
    $("#courseTitle, #moduleNumber, #author, #metafile_title, #metafile_description, .clip_title").val("");
  });

});



