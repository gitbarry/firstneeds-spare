<?php
/**
 * @file
 * This file contains all functions wich need for calendar view.
 */

/**
 * View calendar.
 */
function spider_fc_content_view($cal_id, $cal_theme, $many_sp_calendar) {
  $row = db_query("SELECT appMaxWidth,appMaxHeight FROM {spider_fc_theme_table} WHERE id=:id", array(':id' => $cal_theme))->fetchObject();
  $width = $row->appMaxWidth;
  $height = $row->appMaxHeight;
  $params_xml = url('spider_fc/params_xml', array('query' => array('theme' => $cal_theme), 'absolute' => FALSE));
  $params_xml = str_replace('&', '@', $params_xml);
  $calendar_xml = url('spider_fc/calendar_xml', array('query' => array('calendar' => $cal_id), 'absolute' => FALSE));
  $calendar_xml = str_replace('&', '@', $calendar_xml);
  $lang_xml = url('spider_fc/lang_xml', array('query' => array('theme' => $cal_theme), 'absolute' => FALSE));
  $lang_xml = str_replace('&', '@', $lang_xml);
  $node_view = '
    <div id="flashContent" style=" width:' . $width . 'px; height:' . $height . 'px; text-align:center;">
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="' . $width . '" height="' . $height . '" id="loader" align="middle">
        <param name="movie" value="' . base_path() . drupal_get_path('module', 'spider_fc') . '/loader.swf" />
        <param name="quality" value="high" />
        <param name="bgcolor" value="#ffffff" />
        <param name="play" value="true" />
        <param name="loop" value="true" />
        <param name="wmode" value="window" />
        <param name="scale" value="showall" />
        <param name="menu" value="true" />
        <param name="devicefont" value="false" />
        <param name="salign" value="" />
        <param name="allowScriptAccess" value="sameDomain" />
        <param name="flashvars" value="settingsUrl=' . $params_xml . '&eventsListUrl=' . $calendar_xml . '&langUrl=' . $lang_xml . ' &swfUrl=' . drupal_get_path('module', 'spider_fc') . '/calendar.swf" />
        <!--[if !IE]>-->
        <object type="application/x-shockwave-flash" data="' . base_path() . drupal_get_path('module', 'spider_fc') . '/loader.swf" width="' . $width . '" height="' . $height . '">
          <param name="movie" value="' . base_path() . drupal_get_path('module', 'spider_fc') . '/loader.swf" />
          <param name="quality" value="high" />
          <param name="bgcolor" value="#ffffff" />
          <param name="play" value="true" />
          <param name="loop" value="true" />
          <param name="wmode" value="window" />
          <param name="scale" value="showall" />
          <param name="menu" value="true" />
          <param name="devicefont" value="false" />
          <param name="salign" value="" />
          <param name="allowScriptAccess" value="sameDomain" />
          <param name="flashvars" value="settingsUrl=' . $params_xml . '&eventsListUrl=' . $calendar_xml . '&langUrl=' . $lang_xml . '&swfUrl=' . base_path() . drupal_get_path('module', 'spider_fc') . '/calendar.swf" />
          <!--<![endif]-->
          <a href="http://www.adobe.com/go/getflash">
            <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
          </a>
        <!--[if !IE]>-->
        </object>
        <!--<![endif]-->
      </object>
    </div>';
  return $node_view;
}
