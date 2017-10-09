<?php
/**
 * @file
 * This file allow to translate calendar.
 */

/**
 * Translate calendar.
 */
function spider_fc_lang_xml() {
  $id = $_GET['theme'];
  $result = db_query("SELECT * FROM {spider_fc_theme_table} WHERE id = :id", array(':id' => $id));
  $theme = $result->fetchObject();
  $startwithmonday = $theme->startWithMonday;
  echo '
    <lang>
      <months>' . t('January') . ', ' . t('February') . ', ' . t('March') . ', ' . t('April') . ', ' . t('May') . ', ' . t('June') . ', ' . t('July') . ', ' . t('August') . ', ' . t('September') . ', ' . t('October') . ', ' . t('November') . ', ' . t('December') . '</months>
      <monthsShort>' . t('Jan') . ', ' . t('Feb') . ', ' . t('Mar') . ', ' . t('Apr') . ', ' . t('May') . ', ' . t('Jun') . ', ' . t('Jul') . ', ' . t('Aug') . ', ' . t('Sep') . ', ' . t('Oct') . ', ' . t('Nov') . ', ' . t('Dec') . '</monthsShort>';
  if ($startwithmonday == 1) {
    echo '
      <days>' . t('Monday') . ', ' . t('Tuesday') . ', ' . t('Wednesday') . ', ' . t('Thursday') . ', ' . t('Friday') . ', ' . t('Saturday') . ', ' . t('Sunday') . '</days>
      <daysShort>' . t('Mon') . ', ' . t('Tue') . ', ' . t('Wed') . ', ' . t('Thu') . ', ' . t('Fri') . ', ' . t('Sat') . ', ' . t('Sun') . '</daysShort>';
  }
  else {
    echo '
      <days>' . t('Sunday') . ', ' . t('Monday') . ', ' . t('Tuesday') . ', ' . t('Wednesday') . ', ' . t('Thursday') . ', ' . t('Friday') . ', ' . t('Saturday') . '</days>
      <daysShort>' . t('Sun') . ', ' . t('Mon') . ', ' . t('Tue') . ', ' . t('Wed') . ', ' . t('Thu') . ', ' . t('Fri') . ', ' . t('Sat') . '</daysShort>';
  }
  echo '
      <event>' . t('Event') . '</event>
      <events>' . t('Events') . '</events>
      <priority>' . t('Priority') . '</priority>
      <priority0Text>' . t('None priority') . '</priority0Text>
      <priority1Text>' . t('Low priority') . '</priority1Text>
      <priority2Text>' . t('Medium priority') . '</priority2Text>
      <priority3Text>' . t('High priority') . '</priority3Text>
      
      <time>' . t('Time') . '</time>
      <startDate>' . t('From') . '</startDate>
      <endDate>' . t('to') . '</endDate>
      <eventsListHeaderTitleText>' . t('Events on') . '</eventsListHeaderTitleText>
      <type>Type</type>
    </lang>';
  drupal_add_http_header('Content-Type', 'text/xml; charset=utf-8');
}
