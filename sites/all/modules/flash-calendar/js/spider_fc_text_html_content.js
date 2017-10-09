/**
 * Change event tontent type on radio button click.
 */
function spider_fc_change_event_content_type(type) {
  var text_html_content_div = document.getElementById("spider_fc_div_text_html_content");
  var text_div = document.getElementById("spider_fc_text_div");
  var html_div = document.getElementById("spider_fc_html_div");
  var content_div = document.getElementById("spider_fc_content_div");
  var checked = document.getElementById("checked_hidden_field");
  checked.value = type;
  switch (type) {
    case "text":
      text_div.style.display = "";
      html_div.style.display = "none";
      content_div.style.display = "none";
      break;

    case "html":
      text_div.style.display = "none";
      html_div.style.display = "";
      content_div.style.display = "none";
      break;

    case "content":
      text_div.style.display = "none";
      html_div.style.display = "none";
      content_div.style.display = "";
      break;
  }
}

/**
 * Check the radio on page load.
 */
function spider_fc_check_first(type) {
  var first_checked_radio = document.getElementById("edit-" + type);
  first_checked_radio.checked = "checked";
  spider_fc_change_event_content_type(type);
}
