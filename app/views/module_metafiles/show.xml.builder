# &lt;module xmlns="http://pluralsight.com/sapphire/module/2007/11"&gt;
#   &lt;author&gt;<%= @metafile.author %>&lt;/author&gt;
#   &lt;title&gt;<%= @metafile.course_title %>&lt;/title&gt;
#   &lt;description&gt;<%= @metafile.description %>&lt;/description&gt;
#   &lt;clips&gt;
#     <% @metafile.clips.each do |clip| %>

#     &lt;clip href="<%= clip.href %>" title="<%= clip.title %>" /&gt;
#     <% end %>
#   &lt;/clips&gt;
# &lt;/module&gt;
# xml.instruct!
#   xml.title metafile.title
#   xml.

nope