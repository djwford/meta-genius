module CourseMetafilesHelper

  def help_image(input_text)
    (image_tag "help.svg", size: "19",
      data: { ot: input_text},
      width: "16px", height: "16px", class: "help_image").html_safe
  end

  def course_short_descriptions_link
    "https://authors.pluralsight.com/course-deliverables/short-description/"
  end
  def course_long_descriptions_link
    "https://authors.pluralsight.com/course-deliverables/long-description/"
  end
end
