// Added new upload field sequence number.
var i = 0;
/**
 * Delete uploaded file.
 */
function spider_fc_delete_file(type, j) {
  var uploadsDiv = document.getElementById("viewUploadsDiv");
  switch (type) {
    case "img":
      var removeImageLoader = document.getElementById("imguploaded_id_" + j);
      uploadsDiv.removeChild(removeImageLoader);
      break;

    case "vidHttp":
      var removeVideoLoader = document.getElementById("videouploaded_id_" + j);
      removeVideoLoader.setAttribute("style", "display:none");
      uploadsDiv.removeChild(removeVideoLoader);
      break;

    case "vidYoutube":
      var removeYoutubeLoader = document.getElementById("youtubeuploaded_id_" + j);
      removeYoutubeLoader.setAttribute("style", "display:none");
      uploadsDiv.removeChild(removeYoutubeLoader);
      break;

    case "img_brows":
      var input_file_container = document.getElementById("input_file_container");
      var remove_img_brows = document.getElementById(j);
      input_file_container.removeChild(remove_img_brows);
      break;

    case "video_brows":
      var input_file_container = document.getElementById("input_file_container");
      var remove_video_brows = document.getElementById(j);
      input_file_container.removeChild(remove_video_brows);
      break;

    case "video_youtube":
      var input_file_container = document.getElementById("input_file_container");
      var remove_video_youtube_brows = document.getElementById(j);
      input_file_container.removeChild(remove_video_youtube_brows);
      break;
  }
}

/**
 * Move up uploaded file.
 */
function spider_fc_up_file(id) {
  // Current div wich must be moved.
  var cur_node = document.getElementById(id);
  // Current div's parent div.
  var parent_node = cur_node.parentNode;
  // Parent div's childs array.
  var child_nodes = parent_node.childNodes;
  for (var i = 1; i < child_nodes.length; i++) {
    if (child_nodes[i] == cur_node) {
      // Current div's previous div.
      var previous_node = child_nodes[i - 1];
    }
  }
  // Insert current div before previous div.
  if (previous_node) {
    parent_node.insertBefore(cur_node, previous_node);
  }
}

/**
 * Move down uploaded file.
 */
function spider_fc_down_file(id) {
  // Current div wich must be moved.
  var cur_node = document.getElementById(id);
  // Current div's parent div.
  var parent_node = cur_node.parentNode;
  // Parent div's childs array.
  var child_nodes = parent_node.childNodes;
  for (var i = 0; i < child_nodes.length - 1; i++) {
    if (child_nodes[i] == cur_node) {
      // Current div's next div.
      var next_node = child_nodes[i + 1];
    }
  }
  // Insert next div before current div.
  if (next_node) {
    parent_node.insertBefore(next_node, cur_node);
  }
}

/**
 * Add image upload field.
 */
function spider_fc_add_upload_box() {
  var input_file_container = document.getElementById("input_file_container");
  // Image upload div.
  var inputDiv = document.createElement("div");
  inputDiv.setAttribute("id", "edit-image-upload-wrapper_" + i + "");
  inputDiv.setAttribute("class", "form-item");
  input_file_container.appendChild(inputDiv);
  // Image upload input.
  var inputBox = document.createElement("input");
  inputBox.setAttribute("id", "edit-image-upload");
  inputBox.setAttribute("name", "files[image_upload_" + i + "]");
  inputBox.setAttribute("class", "form-file");
  inputBox.setAttribute("type", "file");
  inputBox.setAttribute("size", "60");
  inputDiv.appendChild(inputBox);
  // Image upload div delete.
  var deleteBox = document.createElement("img");
  deleteBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "delete.png");
  deleteBox.setAttribute("style", "cursor:pointer;");
  deleteBox.setAttribute("onclick", "spider_fc_delete_file('img_brows', 'edit-image-upload-wrapper_" + i + "')");
  inputDiv.appendChild(deleteBox);
  // Image upload div move up.
  // var upBox = document.createElement("img");
  // upBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "up.png");
  // upBox.setAttribute("style", "cursor:pointer;");
  // upBox.setAttribute("onclick", "spider_fc_up_file('edit-image-upload-wrapper_" + i + "')");
  // inputDiv.appendChild(upBox);
  // Image upload div move down.
  // var downBox = document.createElement("img");
  // downBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "down.png");
  // downBox.setAttribute("style", "cursor:pointer;");
  // downBox.setAttribute("onclick", "spider_fc_down_file('edit-image-upload-wrapper_" + i + "')");
  // inputDiv.appendChild(downBox);
  // Image upload div description.
  var description_div = document.createElement("div");
  description_div.setAttribute("class", "description");
  description_div.innerHTML = Drupal.t("Choose jpg or png image files to upload on save event.");
  inputDiv.appendChild(description_div);
  i++;
}

/**
 * Add video upload field.
 */
function spider_fc_add_upload_video_box() {
  var input_file_container = document.getElementById("input_file_container");
  // Video upload div.
  var inputDiv = document.createElement("div");
  inputDiv.setAttribute("id", "edit-video-upload-wrapper_" + i + "");
  inputDiv.setAttribute("class", "form-item");
  input_file_container.appendChild(inputDiv);
  // Video upload input.
  var inputBox = document.createElement("input");
  inputBox.setAttribute("id", "edit-image-upload");
  inputBox.setAttribute("name", "files[video_upload_" + i + "]");
  inputBox.setAttribute("class", "form-file");
  inputBox.setAttribute("type", "file");
  inputBox.setAttribute("size", "60");
  inputDiv.appendChild(inputBox);
  // Video upload div delete.
  var deleteBox = document.createElement("img");
  deleteBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "delete.png");
  deleteBox.setAttribute("style", "cursor:pointer;");
  deleteBox.setAttribute("onclick", "spider_fc_delete_file('video_brows', 'edit-video-upload-wrapper_" + i + "')");
  inputDiv.appendChild(deleteBox);
  // Video upload div move up.
  // var upBox = document.createElement("img");
  // upBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "up.png");
  // upBox.setAttribute("style", "cursor:pointer;");
  // upBox.setAttribute("onclick", "spider_fc_up_file('edit-video-upload-wrapper_" + i + "')");
  // inputDiv.appendChild(upBox);
  // Video upload div move down.
  // var downBox = document.createElement("img");
  // downBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "down.png");
  // downBox.setAttribute("style", "cursor:pointer;");
  // downBox.setAttribute("onclick", "spider_fc_down_file('edit-video-upload-wrapper_" + i + "')");
  // inputDiv.appendChild(downBox);
  // Video upload div description.
  var description_div = document.createElement("div");
  description_div.setAttribute("class", "description");
  description_div.innerHTML = Drupal.t("Choose mp4 or flv  video files to upload on save event.");
  inputDiv.appendChild(description_div);
  i++;
}

/**
 * Add YouTube video upload field.
 */
function spider_fc_add_youtube_video_box() {
  var input_file_container = document.getElementById("input_file_container");
  // Video youtube upload div.
  var inputDiv = document.createElement("div");
  inputDiv.setAttribute("id", "edit-videoyoutube-wrapper_" + i + "");
  inputDiv.setAttribute("class", "form-item");
  input_file_container.appendChild(inputDiv);
  // Video youtube upload input.
  var inputBox = document.createElement("input");
  inputBox.setAttribute("id", "edit-videoyoutube");
  inputBox.setAttribute("name", "videoyoutube_" + i);
  inputBox.setAttribute("class", "form-text");
  inputBox.setAttribute("type", "text");
  inputBox.setAttribute("size", "60");
  inputBox.setAttribute("maxlength", "128");
  inputDiv.appendChild(inputBox);
  // Video youtube upload div delete.
  var deleteBox = document.createElement("img");
  deleteBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "delete.png");
  deleteBox.setAttribute("style", "cursor:pointer;");
  deleteBox.setAttribute("onclick", "spider_fc_delete_file('video_youtube', 'edit-videoyoutube-wrapper_" + i + "')");
  inputDiv.appendChild(deleteBox);
  // Video youtube upload div move up.
  // var upBox = document.createElement("img");
  // upBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "up.png");
  // upBox.setAttribute("style", "cursor:pointer;");
  // upBox.setAttribute("onclick", "spider_fc_up_file('edit-videoyoutube-wrapper_" + i + "')");
  // inputDiv.appendChild(upBox);
  // Video youtube upload div move down.
  // var downBox = document.createElement("img");
  // downBox.setAttribute("src", "" + Drupal.settings.spider_fc.delete_png_url + "down.png");
  // downBox.setAttribute("style", "cursor:pointer;");
  // downBox.setAttribute("onclick", "spider_fc_down_file('edit-videoyoutube-wrapper_" + i + "')");
  // inputDiv.appendChild(downBox);
  // Video youtube upload div description.
  var description_div = document.createElement("div");
  description_div.setAttribute("class", "description");
  description_div.innerHTML = Drupal.t("Enter YouTube video url.");
  inputDiv.appendChild(description_div);
  i++;
}
