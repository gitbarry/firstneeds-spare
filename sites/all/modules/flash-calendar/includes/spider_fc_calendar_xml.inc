<?php
/**
 * @file
 * This file generate flash calendar.
 */

/**
 * Generate flash calendar.
 */
function spider_fc_calendar_xml() {
  $id = $_GET['calendar'];
  $res_event_id = db_query("SELECT id FROM {spider_fc_events_table} WHERE calendar=:calendar AND published=:published", array(
    ':calendar' => $id,
    ':published' => "1"
  ))->fetchCol();
  echo '<?xml version="1.0" encoding="utf-8"?>
      <events>';
  foreach ($res_event_id as $row_id) {
    $value = db_query("SELECT * FROM {spider_fc_events_table} WHERE id = :id", array(':id' => $row_id));
    $row = $value->fetchObject();
    $date_start = substr($row->date_begin, 8, 2) . '-' . substr($row->date_begin, 5, 2) . '-' . substr($row->date_begin, 0, 4);
    $date_end = substr($row->date_end, 8, 2) . '-' . substr($row->date_end, 5, 2) . '-' . substr($row->date_end, 0, 4);
    echo '<eventFree>
            <startDate>' . $date_start . ' ' . substr($row->event_time_begin, 0, 5) . '</startDate>
            <endDate>' . $date_end . ' ' . substr($row->event_time_begin, 6, 5) . '</endDate>
            <title>' . $row->title . '</title>
            <description>';
    if ($row->checked == 'text') {
      echo '  <text>' . $row->text . '</text>
              <html></html>';
    }
    elseif ($row->checked == 'html') {
      echo '  <text></text>
              <html>' . check_plain($row->html) . '</html>';
    }
    elseif ($row->checked == 'content') {
      echo '  <text></text>
              <html>' . $row->contenthtml . '</html>';
    }
    echo '
              <css>' . $row->css . '</css>
              <htmlUrl></htmlUrl>
              <cssUrl></cssUrl>
            </description>
            <media>';
    $item_array = explode('#*type*#', $row->items);
    unset($item_array[0]);
    foreach ($item_array as $item) {
      $image_array_example = explode('#*img*#', $item);
      if ($image_array_example[0] == '') {
        echo '
                  <item type="img" url="' . $image_array_example[1] . '" />';
      }
      $video_array_example = explode('#*vidHttp*#', $item);
      if ($video_array_example[0] == '') {
        echo '
                  <item type="vidHttp" url="' . $video_array_example[1] . '" />';
      }
      $videoyoutube_array_example = explode('#*vidYoutube*#', $item);
      if ($videoyoutube_array_example[0] == '') {
        echo '
                  <item type="vidYoutube" url="' . $videoyoutube_array_example[1] . '" />';
      }
    }
    echo '
            </media>
            <type>' . $row->event_type . '</type>
            <priority>' . $row->priority . '</priority>
          </eventFree>';
  }
  echo '
      </events>';
  drupal_add_http_header('Content-Type', 'text/xml; charset=utf-8');
}
