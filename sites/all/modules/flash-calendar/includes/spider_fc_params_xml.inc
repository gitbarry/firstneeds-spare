<?php
/**
 * @file
 * This file give to flash theme parametres.
 */

/**
 * Change to boolean.
 */
function spider_fc_change_to_bool($x) {
  if ($x) {
    return 'true';
  }
  return 'false';
}

/**
 * Theme parametres give to flash.
 */
function spider_fc_params_xml() {
  $id = $_GET['theme'];
  $result = db_query("SELECT * FROM {spider_fc_theme_table} WHERE id = :id", array(':id' => $id));
  $t = $result->fetchObject();
  echo '<?xml version="1.0" encoding="UTF-8"?>
      <settings>
        <startWithMonday>' . spider_fc_change_to_bool($t->startWithMonday) . '</startWithMonday>
        
        <dateFormat>' . $t->dateFormat . '</dateFormat>
        <dateFormatShort>' . $t->dateFormatShort . '</dateFormatShort>
        <time12Hours>' . spider_fc_change_to_bool($t->time) . '</time12Hours>
        
        <appMaxWidth>' . $t->appMaxWidth . '</appMaxWidth>
        <appMaxHeight>' . $t->appMaxHeight . '</appMaxHeight>
        <appMinWidth>' . $t->appMinWidth . '</appMinWidth>
        <appMinHeight>' . $t->appMinHeight . '</appMinHeight>
        
        <startViewSize>' . $t->startViewSize . '</startViewSize>
        <startViewState>' . $t->startViewState . '</startViewState>
        
        <tweenDuration>0.55</tweenDuration>
        
        <bgColors>0x' . $t->bgColors1 . ', 0x' . $t->bgColors2 . '</bgColors>
        <bgStrokeColor>0x' . $t->bgStrokeColor . '</bgStrokeColor>
        <bgCornerRadius>' . $t->bgCornerRadius . '</bgCornerRadius>
        
        <headerHeight>' . $t->headerHeight . '</headerHeight>
        <headerPadding>' . $t->headerPadding . '</headerPadding>
        <headerBgColors>0x' . $t->headerBgColors1 . ', 0x' . $t->headerBgColors2 . '</headerBgColors>
        <headerBgStrokeColor>0x' . $t->headerBgStrokeColor . '</headerBgStrokeColor>
        <headerContentColor>0x' . $t->headerContentColor . '</headerContentColor>
        <headerContentStrokeColor>0x' . $t->headerContentStrokeColor . '</headerContentStrokeColor>
        <headerFontSize>' . $t->headerFontSize . '</headerFontSize>
        
        <daysNamesColor>0x' . $t->daysNamesColor . '</daysNamesColor>
        <daysNamesFontSize>' . $t->daysNamesFontSize . '</daysNamesFontSize>
        
        <datesBgColors>0x' . $t->datesBgColors1 . ', 0x' . $t->datesBgColors2 . '</datesBgColors>
        <datesBgStrokeColor>0x' . $t->datesBgStrokeColor . '</datesBgStrokeColor>
        
        <priority0Color>0x' . $t->priority0Color . '</priority0Color>
        <priority1Color>0x' . $t->priority1Color . '</priority1Color>
        <priority2Color>0x' . $t->priority2Color . '</priority2Color>
        <priority3Color>0x' . $t->priority3Color . '</priority3Color>
        
        <dateFontSize>' . $t->dateFontSize . '</dateFontSize>
        <dateColor>0x' . $t->dateColor . '</dateColor>
        <dateStrokeColor>0x' . $t->dateStrokeColor . '</dateStrokeColor>
        <showDateEventsCount>' . spider_fc_change_to_bool($t->showDateEventsCount) . '</showDateEventsCount>
        <dateEventsCountFontSize>' . $t->dateEventsCountFontSize . '</dateEventsCountFontSize>
        <dateEventsCountColor>0x' . $t->dateEventsCountColor . '</dateEventsCountColor>
        
        <eventsListHeaderHeight>' . $t->eventsListHeaderHeight . '</eventsListHeaderHeight>
        <eventsListHeaderStrokeColor>0x' . $t->eventsListHeaderStrokeColor . '</eventsListHeaderStrokeColor>
        <eventsListHeaderbgColors>0x' . $t->eventsListHeaderbgColors1 . ', 0x' . $t->eventsListHeaderbgColors2 . '</eventsListHeaderbgColors>
        <eventsListHeaderColor>0x' . $t->eventsListHeaderColor . '</eventsListHeaderColor>
        <eventsListHeaderFontSize>' . $t->eventsListHeaderFontSize . '</eventsListHeaderFontSize>
        
        <eventHeaderHeight>' . $t->eventHeaderHeight . '</eventHeaderHeight>
        <eventHeaderFontSize>' . $t->eventHeaderFontSize . '</eventHeaderFontSize>
        <eventHeaderColor>0x' . $t->eventHeaderColor . '</eventHeaderColor>
        
        <eventContentBgColors>0x' . $t->eventContentBgColors1 . ', 0x' . $t->eventContentBgColors2 . '</eventContentBgColors>
        
        <eventContentDatesFontSize>' . $t->eventContentDatesFontSize . '</eventContentDatesFontSize>
        <eventContentDatesColor>0x' . $t->eventContentDatesColor . '</eventContentDatesColor>
        
        <eventContentDescriptionFontSize>' . $t->eventContentDescriptionFontSize . '</eventContentDescriptionFontSize>
        <eventContentDescriptionColor>0x' . $t->eventContentDescriptionColor . '</eventContentDescriptionColor>
        
        <mediaDefaultAutoplay>' . spider_fc_change_to_bool($t->mediaDefaultAutoplay) . '</mediaDefaultAutoplay>
        <mediaScaleType>' . $t->mediaScaleType . '</mediaScaleType>
        <mediaShowDuration>' . $t->mediaShowDuration . '</mediaShowDuration>
        <videoDefaultVolume>' . $t->videoDefaultVolume / 100 . '</videoDefaultVolume>
        <videoAutoplay>' . spider_fc_change_to_bool($t->videoAutoplay) . '</videoAutoplay>
        
        <mediaBgColor>0x' . $t->mediaBgColor . '</mediaBgColor>
        <mediaCtrlsBgColor>0x' . $t->mediaCtrlsBgColor . '</mediaCtrlsBgColor>
        <mediaCtrlsBgAlpha>' . $t->mediaCtrlsBgAlpha / 100 . '</mediaCtrlsBgAlpha>
        <mediaCtrlsColor>0x' . $t->mediaCtrlsColor . '</mediaCtrlsColor>
        <mediaCtrlsAlpha>' . $t->mediaCtrlsAlpha / 100 . '</mediaCtrlsAlpha>
        
        <footerHeight>' . $t->footerHeight . '</footerHeight>
        <footerColor>0x' . $t->footerColor . '</footerColor>
      </settings>';
  drupal_add_http_header('Content-Type', 'text/xml; charset=utf-8');
}
