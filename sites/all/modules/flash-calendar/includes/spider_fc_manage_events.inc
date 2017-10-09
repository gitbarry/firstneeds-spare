<?php
/**
 * @file
 *
 * Events.
 */

/**
 * Events table.
 */
function spider_fc_manage_events() {
  $form = array();
  if (isset($_GET['cal_id'])) {
    $calendar_id = check_plain($_GET['cal_id']);
  }
  $cal_name = db_query("SELECT title FROM {spider_fc_calendar_table} WHERE id=:id", array(':id' => $calendar_id))->fetchField();
  $form['fieldset_event_buttons'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
  );
  $form['fieldset_event_buttons']['publish_event'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_publish_events'),
    '#value' => t('Publish'),
  );
  $form['fieldset_event_buttons']['unpublish_event'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_unpublish_events'),
    '#value' => t('Unpublish'),
  );
  $form['fieldset_event_buttons']['delete_event'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_delete_selected_events'),
    '#value' => t('Delete'),
    '#attributes' => array('onclick' => 'if (!confirm(Drupal.t("Do you want to delete selected events?"))) {return false;}'),
  );
  $form['fieldset_event_buttons']['event_table_cancel'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_manage_events_cancel'),
    '#value' => t('Cancel'),
  );
  $form['fieldset_event_buttons']['new_event'] = array(
    '#prefix' => l(t('New'), url('admin/settings/spider_fc/calendar/manage_events/new', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE))),
  );
  $form['fieldset_search_event_date'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
  );
  $form['fieldset_search_event_date']['search_event_title'] = array(
    '#type' => 'textfield',
    '#title' => t('Search events by title'),
    '#size' => 25,
    '#default_value' => variable_get('spider_fc_search_event_title', ''),
  );
  $form['fieldset_search_event_date']['search_event_date_button'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_event_seach'),
    '#value' => t('Go'),
  );
  $form['fieldset_search_event_date']['reset_event_date_button'] = array(
    '#type' => 'submit',
    '#value' => t('Reset'),
    '#submit' => array('spider_fc_event_reset'),
  );
  $form['fieldset_events'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
    '#title' => $cal_name . ' ' . t('Calendar Events'),
  );
  $header = array(
    'id' => array('data' => t('ID'), 'field' => 'n.id'),
    'title' => array('data' => t('Title'), 'field' => 'n.title'),
    'date' => array('data' => t('Date'), 'field' => 'n.date_begin'),
    'time' => array('data' => t('Time'), 'field' => 'n.event_time_begin'),
    'published' => array('data' => t('Published')),
    'delete' => array('data' => t('Delete')),
  );
  $options = array();
  $events_ids = db_select('spider_fc_events_table', 'n')
    ->fields('n', array('id'))
    ->condition('n.calendar', $calendar_id, '=')
    ->condition('n.title', '%' . db_like(variable_get('spider_fc_search_event_title', '')) . '%', 'LIKE')
    ->extend('TableSort')
    ->orderByHeader($header)
    ->extend('PagerDefault')
    ->limit(20)
    ->execute()
    ->fetchCol();
  foreach ($events_ids as $event_id) {
    $row = db_query("SELECT * FROM {spider_fc_events_table} WHERE id=:id", array(':id' => $event_id))->fetchObject();
    if ($row->published) {
      $publish_unpublish_png = 'publish.png';
      $publish_unpublish_function = 'unpublish';
    }
    else {
      $publish_unpublish_png = 'unpublish.png';
      $publish_unpublish_function = 'publish';
    }
    $date = $row->date_begin . (($row->date_end == '') ? '' : ' - ' . $row->date_end);
    $options[$row->id] = array(
      'id' => $row->id,
      'title' => array(
        'data' => array(
          '#type' => 'link',
          '#title' => $row->title,
          '#href' => url('admin/settings/spider_fc/calendar/manage_events/new', array('query' => array('cal_id' => $calendar_id, 'event_id' => $row->id), 'absolute' => TRUE)),
        ),
      ),
      'date' => $date,
      'time' => $row->event_time_begin,
      'published' => '<a href="' . url('admin/settings/spider_fc/calendar/manage_events/' . $publish_unpublish_function, array('query' => array('cal_id' => $calendar_id, 'event_id' => $row->id), 'absolute' => TRUE)) . '"><img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/' . $publish_unpublish_png . '" /></a>',
      'delete' => array(
        'data' => array(
          '#type' => 'link',
          '#title' => t('Delete'),
          '#href' => url('admin/settings/spider_fc/calendar/manage_events/delete', array('query' => array('cal_id' => $calendar_id, 'event_id' => $row->id), 'absolute' => TRUE)),
        ),
      ),
    );
  }
  $form['fieldset_events']['events_table'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No event available.'),
    '#suffix' => theme('pager', array('tags' => array())),
  );
  return $form;
}

/**
 * Search in events.
 */
function spider_fc_event_seach($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $calendar_id = check_plain($_GET['cal_id']);
  }
  if ($form_state['values']['search_event_title'] != '') {
    variable_set('spider_fc_search_event_title', $form_state['values']['search_event_title']);
  }
  else {
    variable_set('spider_fc_search_event_title', '');
  }
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE));
}

/**
 * Reset events.
 */
function spider_fc_event_reset($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $calendar_id = check_plain($_GET['cal_id']);
  }
  variable_set('spider_fc_search_event_title', '');
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE));
}

/**
 * Publish selected events.
 */
function spider_fc_publish_events($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_events_table}")) {
    $events_id_col = db_query("SELECT id FROM {spider_fc_events_table}")->fetchCol();
    $flag = FALSE;
    foreach ($events_id_col as $event_id) {
      if (isset($_POST['events_table'][$event_id])) {
        $flag = TRUE;
        db_query("UPDATE {spider_fc_events_table} SET published=:published WHERE id=:id", array(':published' => 1, ':id' => $event_id));
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check an event.'), 'warning', FALSE);
    }
  }
}

/**
 * Publish event.
 */
function spider_fc_manage_events_publish() {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  if (isset($_GET['event_id'])) {
    $event_id = check_plain($_GET['event_id']);
  }
  db_query("UPDATE {spider_fc_events_table} SET published=:published WHERE id=:id", array(':published' => 1, ':id' => $event_id));
  drupal_goto(url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)));
}

/**
 * Unpublish selected events.
 */
function spider_fc_unpublish_events($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_events_table}")) {
    $events_id_col = db_query("SELECT id FROM {spider_fc_events_table}")->fetchCol();
    $flag = FALSE;
    foreach ($events_id_col as $event_id) {
      if (isset($_POST['events_table'][$event_id])) {
        $flag = TRUE;
        db_query("UPDATE {spider_fc_events_table} SET published=:published WHERE id=:id", array(':published' => 0, ':id' => $event_id));
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check an event.'), 'warning', FALSE);
    }
  }
}

/**
 * Unpublish event.
 */
function spider_fc_manage_events_unpublish() {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  if (isset($_GET['event_id'])) {
    $event_id = check_plain($_GET['event_id']);
  }
  db_query("UPDATE {spider_fc_events_table} SET published=:published WHERE id=:id", array(':published' => 0, ':id' => $event_id));
  drupal_goto(url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)));
}

/**
 * Delete selected events.
 */
function spider_fc_delete_selected_events($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_events_table}")) {
    $events_id_col = db_query("SELECT id FROM {spider_fc_events_table}")->fetchCol();
    $flag = FALSE;
    foreach ($events_id_col as $event_id) {
      if (isset($_POST['events_table'][$event_id])) {
        $flag = TRUE;
        db_query("DELETE FROM {spider_fc_events_table} WHERE id=:id", array(':id' => $event_id));
        drupal_set_message(t('Selected events successfully deleted.'), 'status', FALSE);
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check an event.'), 'warning', FALSE);
    }
  }
}

/**
 * Delete event.
 */
function spider_fc_manage_events_delete($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  if (isset($_GET['event_id'])) {
    $event_id = check_plain($_GET['event_id']);
  }
  db_query("DELETE FROM {spider_fc_events_table} WHERE id=:id", array(':id' => $event_id));
  drupal_goto(url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)));
  drupal_set_message(t('Event successfully deleted.'), 'status', FALSE);
}

/**
 * Cancel Manage events.
 */
function spider_fc_manage_events_cancel($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $calendar_id = check_plain($_GET['cal_id']);
  }
  $form_state['redirect'] = url('admin/settings/spider_fc', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE));
}

/**
 * Add or edit event.
 */
function spider_fc_manage_events_new() {
  drupal_add_js(array(
    'spider_fc' => array(
      'delete_png_url' => base_path() . drupal_get_path('module', 'spider_fc') . '/images/',
    ),
    ),
    'setting');
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
    $cal_name = db_query("SELECT title FROM {spider_fc_calendar_table} WHERE id=:id", array(':id' => $cal_id))->fetchField();
  }
  else {
    $cal_id = 1;
    $cal_name = '';
  }
  if (isset($_GET['event_id'])) {
    $event_id = check_plain($_GET['event_id']);
  }
  if (isset($_GET['event_id'])) {
    if (db_query("SELECT * FROM {spider_fc_events_table} WHERE id=:id", array(':id' => $event_id))->fetchObject()) {
      $event_row = db_query("SELECT * FROM {spider_fc_events_table} WHERE id=:id", array(':id' => $event_id))->fetchObject();
      $event_title = $event_row->title;
      $event_date_start = $event_row->date_begin;
      $event_date_end = $event_row->date_end;
      $time_event = $event_row->event_time_begin;
      $time_event1 = drupal_substr($time_event, 0, 2);
      $time_event2 = drupal_substr($time_event, 3, 2);
      $time_event3 = drupal_substr($time_event, 6, 2);
      $time_event4 = drupal_substr($time_event, 9, 2);
      $item_array = explode('#*type*#', $event_row->items);
      unset($item_array[0]);
      $i = 0;
      if ($event_row->items != '') {
        $show_items = '<strong>' . t('Uploaded files') . '</strong>
                       <div id="viewUploadsDiv">';
      }
      else {
        $show_items = '<div id="viewUploadsDiv">';
      }
      foreach ($item_array as $item) {
        $image_array_example = explode('#*img*#', $item);
        if ($image_array_example[0] == '') {
          $show_items .= '<div id="imguploaded_id_' . $i . '">' . $image_array_example[1] . '
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/delete.png" style="cursor: pointer;" onclick=spider_fc_delete_file("img","' . $i . '")>
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/up.png" style="cursor: pointer;" onclick=spider_fc_up_file("imguploaded_id_' . $i . '")>
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/down.png" style="cursor: pointer;" onclick=spider_fc_down_file("imguploaded_id_' . $i . '")>
                            <input type="hidden" name="delete_img_' . $i . '" value="#*type*##*img*#' . $image_array_example[1] . '" >
                          </div>';
        }
        $video_array_example = explode('#*vidHttp*#', $item);
        if ($video_array_example[0] == '') {
          $show_items .= '<div id="videouploaded_id_' . $i . '">' . $video_array_example[1] . '
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/delete.png" style="cursor: pointer;" onclick=spider_fc_delete_file("vidHttp","' . $i . '")>
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/up.png" style="cursor: pointer;" onclick=spider_fc_up_file("videouploaded_id_' . $i . '")>
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/down.png" style="cursor: pointer;" onclick=spider_fc_down_file("videouploaded_id_' . $i . '")>
                            <input type="hidden" name="delete_vidHttp_' . $i . '" value="#*type*##*vidHttp*#' . $video_array_example[1] . '" >
                          </div>';
        }
        $videoyoutube_array_example = explode('#*vidYoutube*#', $item);
        if ($videoyoutube_array_example[0] == '') {
          $show_items .= '<div id="youtubeuploaded_id_' . $i . '">' . $videoyoutube_array_example[1] . '
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/delete.png" style="cursor: pointer;" onclick=spider_fc_delete_file("vidYoutube","' . $i . '")>
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/up.png" style="cursor: pointer;" onclick=spider_fc_up_file("youtubeuploaded_id_' . $i . '")>
                            <img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/down.png" style="cursor: pointer;" onclick=spider_fc_down_file("youtubeuploaded_id_' . $i . '")>
                            <input type="hidden" name="delete_vidYoutube_' . $i . '" value="#*type*##*vidYoutube*#' . $videoyoutube_array_example[1] . '" >
                          </div>';
        }
        ++$i;
      }
      $show_items .= '</div>';
      $text_event = $event_row->text;
      $html_event = $event_row->html;
      $css_event = $event_row->css;
      $content_id = $event_row->content_id;
      $checked = $event_row->checked;
      $type_event = $event_row->event_type;
      $priority_event = $event_row->priority;
      $published_event = $event_row->published;
    }
  }
  else {
    $event_title = '';
    $event_date_start = '';
    $event_date_end = '';
    $time_event1 = '';
    $time_event2 = '';
    $time_event3 = '';
    $time_event4 = '';
    $show_items = '';
    $text_event = '';
    $html_event = '';
    $css_event = '';
    $content_id = 0;
    $checked = 'text';
    $type_event = '';
    $priority_event = '';
    $published_event = 1;
  }
  drupal_add_css(drupal_get_path('module', 'spider_fc') . '/css/spider_fc_event_filedset.css');
  drupal_add_css(drupal_get_path('module', 'spider_fc') . '/css/spider_fc_cal.css');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_cal.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_check_hour.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_attach_file.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_text_html_content.js');

  $form = array();
  $form['event'] = array(
    '#type' => 'fieldset',
    '#title' => $cal_name . ' ' . t('Calendar Event'),
    '#attributes' => array('class' => array('spider_fc_event_filedset')),
  );
  $form['event']['event_title'] = array(
    '#type' => 'textfield',
    '#title' => t('Title'),
    '#required' => TRUE,
    '#default_value' => $event_title,
    '#size' => 10,
  );
  $form['event']['event_date_start'] = array(
    '#type' => 'textfield',
    '#title' => t('Date start'),
    '#default_value' => $event_date_start,
    '#size' => 15,
    '#attributes' => array(
      'id' => 'event_date_start',
      'name' => 'event_date_start',
    ),
  );
  $form['event']['event_date_start_button'] = array(
    '#type' => 'submit',
    '#value' => t('...'),
    '#attributes' => array(
      'onclick' => 'return showCalendar("event_date_start","%Y-%m-%d");',
      'class' => array('event_date_button'),
    ),
  );
  $form['event']['event_date_end'] = array(
    '#type' => 'textfield',
    '#title' => t('Date end'),
    '#default_value' => $event_date_end,
    '#size' => 15,
    '#attributes' => array(
      'id' => 'event_date_end',
      'name' => 'event_date_end',
    ),
  );
  $form['event']['event_date_end_button'] = array(
    '#type' => 'submit',
    '#value' => t('...'),
    '#attributes' => array(
      'onclick' => 'return showCalendar("event_date_end","%Y-%m-%d");',
      'class' => array('event_date_button'),
    ),
  );
  $form['event']['event_time_begin_minute'] = array(
    '#type' => 'textfield',
    '#title' => t('Time'),
    '#default_value' => $time_event1,
    '#size' => 2,
    '#attributes' => array(
      'id' => 'time_event1',
      'onkeypress' => 'return spider_fc_checkhour("time_event1")',
      'onblur' => 'spider_fc_add_0("time_event1")',
    ),
    '#suffix' => ' : ',
  );
  $form['event']['event_time_begin_second'] = array(
    '#type' => 'textfield',
    '#default_value' => $time_event2,
    '#size' => 2,
    '#attributes' => array(
      'id' => 'time_event2',
      'onkeypress' => 'return spider_fc_checkminute("time_event2")',
      'onblur' => 'spider_fc_add_0("time_event2")',
    ),
    '#suffix' => ' - ',
  );
  $form['event']['event_time_end_minute'] = array(
    '#type' => 'textfield',
    '#default_value' => $time_event3,
    '#size' => 2,
    '#attributes' => array(
      'id' => 'time_event3',
      'onkeypress' => 'return spider_fc_checkhour("time_event3")',
      'onblur' => 'spider_fc_add_0("time_event3")',
    ),
    '#suffix' => ' : ',
  );
  $form['event']['event_time_end_second'] = array(
    '#type' => 'textfield',
    '#default_value' => $time_event4,
    '#size' => 2,
    '#attributes' => array(
      'id' => 'time_event4',
      'onkeypress' => 'return spider_fc_checkminute("time_event4")',
      'onblur' => 'spider_fc_add_0("time_event4")',
    ),
    '#suffix' => '<br /><br />' . $show_items . '
                  <div id="input_file_container"></div><br />
                  <input type="button" value="' . t('Add Image') . '" onclick="spider_fc_add_upload_box();" class="form-submit"></input>
                  <input type="button" value="' . t('Add Video') . '" onclick="spider_fc_add_upload_video_box();" class="form-submit"></input>
                  <input type="button" value="' . t('Add Video from YouTube') . '" onclick="spider_fc_add_youtube_video_box();" class="form-submit"></input>
                  <br /><br />',
  );
  $form['#attributes'] = array('enctype' => 'multipart/form-data');
  if (file_exists("sites/all/libraries/tinymce/jscripts/tiny_mce/tiny_mce.js")) {
    drupal_add_js('sites/all/libraries/tinymce/jscripts/tiny_mce/tiny_mce.js');
    drupal_add_js('tinyMCE.init({
				// General options
        mode : "specific_textareas",
        editor_selector : "spider_fc_editor",
				theme : "advanced",
				plugins : "autolink,lists,spellchecker,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template",
				// Theme options
				theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
				theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
				theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
				theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,spellchecker,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,blockquote,pagebreak,|,insertfile,insertimage",
				theme_advanced_toolbar_location : "top",
				theme_advanced_toolbar_align : "left",
				theme_advanced_statusbar_location : "bottom",
				theme_advanced_resizing : true,

				// Skin options
				skin : "o2k7",
				skin_variant : "silver",

				// Example content CSS (should be your site CSS)
				//content_css : "css/example.css",
				
				// Drop lists for link/image/media/template dialogs
				template_external_list_url : "js/template_list.js",
				external_link_list_url : "js/link_list.js",
				external_image_list_url : "js/image_list.js",
				media_external_list_url : "js/media_list.js",

				// Replace values for the template plugin
				template_replace_values : {
					username : "Some User",
					staffid : "991234"
				}
			});', array('type' => 'inline', 'scope' => 'footer'));
  }
  drupal_add_js('spider_fc_check_first("' . $checked . '")', array('type' => 'inline', 'scope' => 'footer'));
  $form['event']['checked_hidden_field'] = array(
    '#type' => 'hidden',
    '#default_value' => $checked,
    '#attributes' => array('id' => 'checked_hidden_field'),
  );
  // Radio buttons.
  $form['event']['text'] = array(
    '#type' => 'radio',
    '#title' => t('Text'),
    '#title_display' => 'after',
    '#attributes' => array(
      'onclick' => 'spider_fc_change_event_content_type("text")',
      'name' => 'text_html_content',
      'checked' => 'disabled',
    ),
  );
  $form['event']['html'] = array(
    '#type' => 'radio',
    '#title' => t('HTML'),
    '#title_display' => 'after',
    '#attributes' => array(
      'onclick' => 'spider_fc_change_event_content_type("html")',
      'name' => 'text_html_content',
      'checked' => 'checked',
    ),
  );
  $form['event']['content'] = array(
    '#type' => 'radio',
    '#title' => t('Content'),
    '#title_display' => 'after',
    '#attributes' => array(
      'onclick' => 'spider_fc_change_event_content_type("content")',
      'name' => 'text_html_content',
      'checked' => 'unchecked',
    ),
  );
  // Text-html-content div.
  // Text div.
  $form['event']['text_field'] = array(
    '#prefix' => '<div id="spider_fc_div_text_html_content"><div id="spider_fc_text_div">',
    '#type' => 'textarea',
    '#title' => t('Text'),
    '#default_value' => $text_event,
    '#attributes' => array(
      'id' => 'text_field',
      'name' => 'text_field',
    ),
    '#suffix' => '</div>',
  );
  // HTML div.
  $editor_warning = '<div style="position:relative; background-color:#FEF5F1; color:#8C2E0B; border-color:#ED541D; padding:2px; border:1px solid #DD7777;">
                      ' . t('To show HTML editor download \'tinymce\' library from') . ' ' . l(t('http://github.com/downloads/tinymce/tinymce/tinymce_3.5.7.zip'), 'http://github.com/downloads/tinymce/tinymce/tinymce_3.5.7.zip') . ' ' . t('and extract it to sites/all/libraries/tinymce directory.') . '
                     </div>';
  $form['event']['html_field'] = array(
    '#prefix' => '<div id="spider_fc_html_div">' . (file_exists("sites/all/libraries/tinymce/jscripts/tiny_mce/tiny_mce.js") ? '' : $editor_warning),
    '#type' => 'textarea',
    '#title' => t('HTML'),
    '#default_value' => $html_event,
    '#attributes' => array(
      'id' => 'html_field',
      'name' => 'html_field',
      'class' => array('spider_fc_editor'),
    ),
  );
  $form['event']['html_css_field'] = array(
    '#type' => 'textarea',
    '#title' => t('CSS'),
    '#default_value' => $css_event,
    '#attributes' => array(
      'id' => 'html_css_field',
      'name' => 'html_css_field',
    ),
    '#suffix' => '</div>',
  );
  // Content div.
  $node_titles_array_id_indexes = db_query("SELECT nid,title FROM {node} ORDER BY title")->fetchAllKeyed();
  $node_titles_array_id_indexes[0] = t('-Select content-');
  $form['event']['content_field'] = array(
    '#prefix' => '<div id="spider_fc_content_div">',
    '#type' => 'select',
    '#title' => t('Content'),
    '#default_value' => $content_id,
    '#options' => $node_titles_array_id_indexes,
    '#attributes' => array(
      'id' => 'content_field',
      'name' => 'content_field',
    ),
  );
  $form['event']['content_css_field'] = array(
    '#type' => 'textarea',
    '#title' => t('CSS'),
    '#default_value' => $css_event,
    '#attributes' => array(
      'id' => 'content_css_field',
      'name' => 'content_css_field',
    ),
    '#suffix' => '</div></div>',
  );

  $form['event']['type_event'] = array(
    '#title' => t('Type'),
    '#type' => 'textfield',
    '#size' => 40,
    '#default_value' => $type_event,
  );
  $form['event']['priority_event'] = array(
    '#type' => 'select',
    '#title' => t('Priority'),
    '#size' => '1',
    '#options' => array(
      t('No Priority'),
      t('Low Priority'),
      t('Medium Priority'),
      t('High Priority'),
    ),
    '#default_value' => $priority_event,
  );
  $form['event']['published_event'] = array(
    '#type' => 'radios',
    '#title' => t('Published'),
    '#default_value' => $published_event,
    '#options' => array('1' => t('Yes'), '0' => t('No'),
    ),
  );
  $form['event_save'] = array(
    '#type' => 'submit',
    '#prefix' => '<div style="float:left; bottom:0px; clear:both;">',
    '#value' => t('Save'),
    '#submit' => array('spider_fc_event_save'),
  );
  $form['event_apply'] = array(
    '#type' => 'submit',
    '#value' => t('Apply'),
    '#submit' => array('spider_fc_event_apply'),
  );
  $form['event_cancel'] = array(
    '#type' => 'submit',
    '#value' => t('Cancel'),
    '#attributes' => array('onclick' => 'document.getElementById("edit-event-title").setAttribute("style", "color:rgba(255, 0, 0, 0)");document.getElementById("edit-event-title").setAttribute("value", "cancel");'),
    '#submit' => array('spider_fc_event_cancel'),
    '#suffix' => '</div>',
  );
  // Check if post max size is smaller than this form post.
  $post_max_size_error = error_get_last();
  if ($post_max_size_error) {
    drupal_set_message($post_max_size_error['message'] . t('. Change "post_max_size" in .htaccess file.'), 'error', FALSE);
  }
  return $form;
}

/**
 * Save event.
 */
function spider_fc_event_save($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $calendar_id = check_plain($_GET['cal_id']);
  }
  $title_event = $form_state['values']['event_title'];
  $date_start_event = $form_state['values']['event_date_start'];
  $date_end_event = $form_state['values']['event_date_end'];
  $time_event1 = $form_state['values']['event_time_begin_minute'];
  $time_event2 = $form_state['values']['event_time_begin_second'];
  $time_event3 = $form_state['values']['event_time_end_minute'];
  $time_event4 = $form_state['values']['event_time_end_second'];
  if (($time_event1 != '') && ($time_event2 != '')) {
    $time_event = $time_event1 . ':' . $time_event2;
    if (($time_event3 != '') && ($time_event4 != '')) {
      $time_event .= '-' . $time_event3 . ':' . $time_event4;
    }
  }
  else {
    $time_event = '';
  }
  $dir = 'public://';
  $upload_event = array();
  if ($_FILES) {
    foreach ($_FILES['files']['name'] as $key => $value) {
      if (drupal_substr($key, 0, 12) == 'image_upload') {
        $image_name = $_FILES['files']['name'][$key];
        $image_size = $_FILES['files']['size'][$key];
        $image_type = $_FILES['files']['type'][$key];
        $validators = array(
           'file_validate_extensions' => array('jpg jpeg png gif'),
        );
        $image_file = file_save_upload($key, $validators, $dir);
        $image_file->status = FILE_STATUS_PERMANENT;
        file_save($image_file);
        if ($image_file) {
          $pos = drupal_strlen($key) - strrpos($key, '_') - 1;
          $index = drupal_substr($key, -$pos);
          $upload_event[$index] = '#*type*##*img*#' . base_path() . 'sites/default/files/' . $image_name;
        }
      }
      elseif (drupal_substr($key, 0, 12) == 'video_upload') {
        $video_name = $_FILES['files']['name'][$key];
        $video_size = $_FILES['files']['size'][$key];
        $video_type = $_FILES['files']['type'][$key];
        $validators = array(
           'file_validate_extensions' => array('flv mp4 m4v f4v'),
        );
        $video_file = file_save_upload($key, $validators, $dir);
        $video_file->status = FILE_STATUS_PERMANENT;
        file_save($video_file);
        if ($video_file) {
          $pos = drupal_strlen($key) - strrpos($key, '_') - 1;
          $index = drupal_substr($key, -$pos);
          $upload_event[$index] = '#*type*##*vidHttp*#' . base_path() . 'sites/default/files/' . $video_name;
        }
      }
    }
  }
  foreach ($_POST as $key => $value) {
    if (drupal_substr($key, 0, 12) == 'videoyoutube') {
      $pos = drupal_strlen($key) - strrpos($key, '_') - 1;
      $index = drupal_substr($key, -$pos);
      $upload_event[$index] = '#*type*##*vidYoutube*#' . $value;
    }
  }
  // Array to string.
  if (!isset($items)) {
    $items = '';
  }
  // Add to files list old uploaded files.
  foreach ($_POST as $key => $value) {
    if (drupal_substr($key, 0, 10) == 'delete_img') {
      $items .= $value;
    }
    elseif (drupal_substr($key, 0, 14) == 'delete_vidHttp') {
      $items .= $value;
    }
    elseif (drupal_substr($key, 0, 17) == 'delete_vidYoutube') {
      $items .= $value;
    }
  }
  // Add to files list new uploaded files.
  foreach ($upload_event as $upload_event_value) {
    $items .= $upload_event_value;
  }
  $text_event = $form_state['values']['text_field'];
  $html_event = $form_state['values']['html_field'];
  $checked = $form_state['values']['checked_hidden_field'];
  if ($checked == 'html') {
    $css_event = $form_state['values']['html_css_field'];
  }
  else {
    $css_event = $form_state['values']['content_css_field'];
  }
  $content_id = $form_state['values']['content_field'];
  $content_html_event = db_query("SELECT body_value FROM {field_data_body} WHERE entity_id=:entity_id", array(':entity_id' => $content_id))->fetchField();
  $type_event = $form_state['values']['type_event'];
  $priority_event = $form_state['values']['priority_event'];
  $published_event = $form_state['values']['published_event'];

  if (isset($_GET['event_id'])) {
    $event_id = check_plain($_GET['event_id']);
    $calendar = check_plain($_GET['cal_id']);
    db_query("UPDATE {spider_fc_events_table} SET 
      title=:title,
      calendar=:calendar,
      date_begin=:date_begin,
      date_end=:date_end,
      event_time_begin=:event_time_begin,
      text=:text,
      html=:html,
      css=:css,
      contenthtml=:contenthtml,
      content_id=:content_id,
      checked=:checked,
      event_type=:event_type,
      priority=:priority,
      published=:published,
      items=:items WHERE id=:id", array(
      ':title' => $title_event,
      ':calendar' => $calendar,
      ':date_begin' => $date_start_event,
      ':date_end' => $date_end_event,
      ':event_time_begin' => $time_event,
      ':text' => $text_event,
      ':html' => $html_event,
      ':css' => $css_event,
      ':contenthtml' => $content_html_event,
      ':content_id' => $content_id,
      ':checked' => $checked,
      ':event_type' => $type_event,
      ':priority' => $priority_event,
      ':published' => $published_event,
      ':items' => $items,
      ':id' => $event_id));
    drupal_set_message(t('Your event successfully updated.'), 'status', FALSE);
  }
  else {
    $count = db_query("SELECT COUNT(*) FROM {spider_fc_events_table}")->fetchField();
    if ($count >= 3) {
      drupal_set_message(t('To add more than three events, download the full version on') . ' ' . l(t('drupal.org.'), 'http://drupal.org/project/flash-calendar'), 'error', FALSE);
      $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE));
      return;
    }
    $calendar = check_plain($_GET['cal_id']);
    db_insert('spider_fc_events_table')
      ->fields(array(
        'title' => $title_event,
        'calendar' => $calendar,
        'date_begin' => $date_start_event,
        'date_end' => $date_end_event,
        'event_time_begin' => $time_event,
        'text' => $text_event,
        'html' => $html_event,
        'css' => $css_event,
        'contenthtml' => $content_html_event,
        'content_id' => $content_id,
        'checked' => $checked,
        'event_type' => $type_event,
        'priority' => $priority_event,
        'published' => $published_event,
        'items' => $items,
        'checked' => $checked,
        ))
      ->execute();
    drupal_set_message(t('Your event successfully saved.'), 'status', FALSE);
  }
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE));
}

/**
 * Apply event.
 */
function spider_fc_event_apply($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $calendar_id = check_plain($_GET['cal_id']);
  }
  $title_event = $form_state['values']['event_title'];
  $date_start_event = $form_state['values']['event_date_start'];
  $date_end_event = $form_state['values']['event_date_end'];
  $time_event1 = $form_state['values']['event_time_begin_minute'];
  $time_event2 = $form_state['values']['event_time_begin_second'];
  $time_event3 = $form_state['values']['event_time_end_minute'];
  $time_event4 = $form_state['values']['event_time_end_second'];
  if (($time_event1 != '') && ($time_event2 != '')) {
    $time_event = $time_event1 . ':' . $time_event2;
    if (($time_event3 != '') && ($time_event4 != '')) {
      $time_event .= '-' . $time_event3 . ':' . $time_event4;
    }
  }
  else {
    $time_event = '';
  }
  $dir = 'public://';
  $upload_event = array();
  if ($_FILES) {
    foreach ($_FILES['files']['name'] as $key => $value) {
      if (drupal_substr($key, 0, 12) == 'image_upload') {
        $image_name = $_FILES['files']['name'][$key];
        $image_size = $_FILES['files']['size'][$key];
        $image_type = $_FILES['files']['type'][$key];
        $validators = array(
           'file_validate_extensions' => array('jpg jpeg png gif'),
        );
        $image_file = file_save_upload($key, $validators, $dir);
        $image_file->status = FILE_STATUS_PERMANENT;
        file_save($image_file);
        if ($image_file) {
          $pos = drupal_strlen($key) - strrpos($key, '_') - 1;
          $index = drupal_substr($key, -$pos);
          $upload_event[$index] = '#*type*##*img*#' . base_path() . 'sites/default/files/' . $image_name;
        }
      }
      elseif (drupal_substr($key, 0, 12) == 'video_upload') {
        $video_name = $_FILES['files']['name'][$key];
        $video_size = $_FILES['files']['size'][$key];
        $video_type = $_FILES['files']['type'][$key];
        $validators = array(
           'file_validate_extensions' => array('flv mp4 m4v f4v'),
        );
        $video_file = file_save_upload($key, $validators, $dir);
        $video_file->status = FILE_STATUS_PERMANENT;
        file_save($video_file);
        if ($video_file) {
          $pos = drupal_strlen($key) - strrpos($key, '_') - 1;
          $index = drupal_substr($key, -$pos);
          $upload_event[$index] = '#*type*##*vidHttp*#' . base_path() . 'sites/default/files/' . $video_name;
        }
      }
    }
  }
  foreach ($_POST as $key => $value) {
    if (drupal_substr($key, 0, 12) == 'videoyoutube') {
      $pos = drupal_strlen($key) - strrpos($key, '_') - 1;
      $index = drupal_substr($key, -$pos);
      $upload_event[$index] = '#*type*##*vidYoutube*#' . $value;
    }
  }
  // Array to string.
  if (!isset($items)) {
    $items = '';
  }
  // Add to files list old uploaded files.
  foreach ($_POST as $key => $value) {
    if (drupal_substr($key, 0, 10) == 'delete_img') {
      $items .= $value;
    }
    elseif (drupal_substr($key, 0, 14) == 'delete_vidHttp') {
      $items .= $value;
    }
    elseif (drupal_substr($key, 0, 17) == 'delete_vidYoutube') {
      $items .= $value;
    }
  }
  // Add to files list new uploaded files.
  foreach ($upload_event as $upload_event_value) {
    $items .= $upload_event_value;
  }
  $text_event = $form_state['values']['text_field'];
  $html_event = $form_state['values']['html_field'];
  $checked = $form_state['values']['checked_hidden_field'];
  if ($checked == 'html') {
    $css_event = $form_state['values']['html_css_field'];
  }
  else {
    $css_event = $form_state['values']['content_css_field'];
  }
  $content_id = $form_state['values']['content_field'];
  $content_html_event = db_query("SELECT body_value FROM {field_data_body} WHERE entity_id=:entity_id", array(':entity_id' => $content_id))->fetchField();
  $type_event = $form_state['values']['type_event'];
  $priority_event = $form_state['values']['priority_event'];
  $published_event = $form_state['values']['published_event'];

  if (isset($_GET['event_id'])) {
    $event_id = check_plain($_GET['event_id']);
    $calendar = check_plain($_GET['cal_id']);
    db_query("UPDATE {spider_fc_events_table} SET 
      title=:title,
      calendar=:calendar,
      date_begin=:date_begin,
      date_end=:date_end,
      event_time_begin=:event_time_begin,
      text=:text,
      html=:html,
      css=:css,
      contenthtml=:contenthtml,
      content_id=:content_id,
      checked=:checked,
      event_type=:event_type,
      priority=:priority,
      published=:published,
      items=:items WHERE id=:id", array(
      ':title' => $title_event,
      ':calendar' => $calendar,
      ':date_begin' => $date_start_event,
      ':date_end' => $date_end_event,
      ':event_time_begin' => $time_event,
      ':text' => $text_event,
      ':html' => $html_event,
      ':css' => $css_event,
      ':contenthtml' => $content_html_event,
      ':content_id' => $content_id,
      ':checked' => $checked,
      ':event_type' => $type_event,
      ':priority' => $priority_event,
      ':published' => $published_event,
      ':items' => $items,
      ':id' => $event_id));
    drupal_set_message(t('Your event successfully updated.'), 'status', FALSE);
  }
  else {
    $count = db_query("SELECT COUNT(*) FROM {spider_fc_events_table}")->fetchField();
    if ($count >= 3) {
      drupal_set_message(t('To add more than three events, download the full version on') . ' ' . l(t('drupal.org.'), 'http://drupal.org/project/flash-calendar'), 'error', FALSE);
      $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $calendar_id), 'absolute' => TRUE));
      return;
    }
    $calendar = check_plain($_GET['cal_id']);
    db_insert('spider_fc_events_table')
      ->fields(array(
        'title' => $title_event,
        'calendar' => $calendar,
        'date_begin' => $date_start_event,
        'date_end' => $date_end_event,
        'event_time_begin' => $time_event,
        'text' => $text_event,
        'html' => $html_event,
        'css' => $css_event,
        'contenthtml' => $content_html_event,
        'content_id' => $content_id,
        'checked' => $checked,
        'event_type' => $type_event,
        'priority' => $priority_event,
        'published' => $published_event,
        'items' => $items,
        'checked' => $checked,
        ))
      ->execute();
    $event_id = db_query("SELECT MAX(id) FROM {spider_fc_events_table}")->fetchField();
    drupal_set_message(t('Your event successfully saved.'), 'status', FALSE);
  }
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events/new', array('query' => array('cal_id' => $calendar_id, 'event_id' => $event_id), 'absolute' => TRUE));
}

/**
 * Cancel event save.
 */
function spider_fc_event_cancel($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE));
}
