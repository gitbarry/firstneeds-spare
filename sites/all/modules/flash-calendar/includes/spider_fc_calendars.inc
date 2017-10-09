<?php
/**
 * @file
 *
 * Spider FC settings.
 */

/**
 * Calendar table.
 */
function spider_fc_calendars() {
  $form['fieldset_cal_buttons'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
  );
  $form['fieldset_cal_buttons']['publish_calendar'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_publish_calendars'),
    '#value' => t('Publish'),
  );
  $form['fieldset_cal_buttons']['unpublish_calendar'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_unpublish_calendars'),
    '#value' => t('Unpublish'),
  );
  $form['fieldset_cal_buttons']['delete_calendar'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_delete_selected_calendar'),
    '#value' => t('Delete'),
    '#attributes' => array('onclick' => 'if (!confirm(Drupal.t("Do you want to delete selected calendars?"))) {return false;}'),
  );
  $form['fieldset_cal_buttons']['new_calendar'] = array(
    '#prefix' => l(t('New'), url('admin/settings/spider_fc/calendar/new', array('absolute' => TRUE))),
  );
  $form['fieldset_search_cal_title'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
  );
  $form['fieldset_search_cal_title']['search_cal_title'] = array(
    '#type' => 'textfield',
    '#title' => t('Search calendars by title'),
    '#size' => 25,
    '#default_value' => variable_get('spider_fc_search_cal_title', ''),
  );
  $form['fieldset_search_cal_title']['search_cal_button'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_cal_search'),
    '#value' => t('Go'),
  );
  $form['fieldset_search_cal_title']['reset_cal_button'] = array(
    '#type' => 'submit',
    '#value' => t('Reset'),
    '#submit' => array('spider_fc_cal_reset'),
  );
  $form['fieldset_calendars'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
    '#title' => t('Calendars'),
  );
  $header = array(
    'id' => array('data' => t('ID'), 'field' => 'n.id'),
    'title' => array('data' => t('Title'), 'field' => 'n.title'),
    'manage_events' => array('data' => t('Manage events')),
    'published' => array('data' => t('Published')),
    'delete' => array('data' => t('Delete')),
  );
  $options = array();
  $cal_ids = db_select('spider_fc_calendar_table', 'n')
    ->fields('n', array('id'))
    ->condition('n.title', '%' . db_like(variable_get('spider_fc_search_cal_title', '')) . '%', 'LIKE')
    ->extend('TableSort')
    ->orderByHeader($header)
    ->extend('PagerDefault')
    ->limit(20)
    ->execute()
    ->fetchCol();
  foreach ($cal_ids as $cal_id) {
    $row = db_query("SELECT * FROM {spider_fc_calendar_table} WHERE id=:id", array(':id' => $cal_id))->fetchObject();
    if ($row->published) {
      $publish_unpublish_png = 'publish.png';
      $publish_unpublish_function = 'unpublish';
    }
    else {
      $publish_unpublish_png = 'unpublish.png';
      $publish_unpublish_function = 'publish';
    }
    $options[$row->id] = array(
      'id' => $row->id,
      'title' => array(
        'data' => array(
          '#type' => 'link',
          '#title' => $row->title,
          '#href' => url('admin/settings/spider_fc/calendar/edit', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)),
        ),
      ),
      'manage_events' => array(
        'data' => array(
          '#type' => 'link',
          '#title' => t('Manage events'),
          '#href' => url('admin/settings/spider_fc/calendar/manage_events', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)),
        ),
      ),
      'published' => '<a href="' . url('admin/settings/spider_fc/' . $publish_unpublish_function, array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)) . '"><img src="' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/' . $publish_unpublish_png . '" /></a>',
      'delete' => array(
        'data' => array(
          '#type' => 'link',
          '#title' => t('Delete'),
          '#href' => url('admin/settings/spider_fc/delete', array('query' => array('cal_id' => $cal_id), 'absolute' => TRUE)),
        ),
      ),
    );
  }
  $form['fieldset_calendars']['calendars_table'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No calendar available.'),
    '#attributes' => array('id' => 'slides-order'),
    '#suffix' => theme('pager', array('tags' => array())),
  );
  return $form;
}

/**
 * Search in calendars.
 */
function spider_fc_cal_search($form, &$form_state) {
  if ($form_state['values']['search_cal_title'] != '') {
    variable_set('spider_fc_search_cal_title', $form_state['values']['search_cal_title']);
  }
  else {
    variable_set('spider_fc_search_cal_title', '');
  }
  $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
}

/**
 * Reset calendars.
 */
function spider_fc_cal_reset($form, &$form_state) {
  variable_set('spider_fc_search_cal_title', '');
  $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
}

/**
 * Publish selected calendars.
 */
function spider_fc_publish_calendars($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_calendar_table}")) {
    $cal_ids_col = db_query("SELECT id FROM {spider_fc_calendar_table}")->fetchCol();
    $flag = FALSE;
    foreach ($cal_ids_col as $cal_id) {
      if (isset($_POST['calendars_table'][$cal_id])) {
        $flag = TRUE;
        db_query("UPDATE {spider_fc_calendar_table} SET published=:published WHERE id=:id", array(':published' => 1, ':id' => $cal_id));
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check a calendar.'), 'warning', FALSE);
    }
  }
}

/**
 * Publish calendar.
 */
function spider_fc_publish_calendar() {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  db_query("UPDATE {spider_fc_calendar_table} SET published=:published WHERE id=:id", array(':published' => 1, ':id' => $cal_id));
  drupal_goto(url('admin/settings/spider_fc', array('absolute' => TRUE)));
}

/**
 * Unpublish selected calendars.
 */
function spider_fc_unpublish_calendars($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_calendar_table}")) {
    $cal_ids_col = db_query("SELECT id FROM {spider_fc_calendar_table}")->fetchCol();
    $flag = FALSE;
    foreach ($cal_ids_col as $cal_id) {
      if (isset($_POST['calendars_table'][$cal_id])) {
        $flag = TRUE;
        db_query("UPDATE {spider_fc_calendar_table} SET published=:published WHERE id=:id", array(':published' => 0, ':id' => $cal_id));
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check a calendar.'), 'warning', FALSE);
    }
  }
}

/**
 * Unpublish calendar.
 */
function spider_fc_unpublish_calendar() {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  db_query("UPDATE {spider_fc_calendar_table} SET published=:published WHERE id=:id", array(':published' => 0, ':id' => $cal_id));
  drupal_goto(url('admin/settings/spider_fc', array('absolute' => TRUE)));
}

/**
 * Delete selected calendars.
 */
function spider_fc_delete_selected_calendar($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_calendar_table}")) {
    $cal_ids_col = db_query("SELECT id FROM {spider_fc_calendar_table}")->fetchCol();
    $flag = FALSE;
    foreach ($cal_ids_col as $cal_id) {
      if (isset($_POST['calendars_table'][$cal_id])) {
        $flag = TRUE;
        db_query("DELETE FROM {spider_fc_calendar_table} WHERE id = :id", array(':id' => $cal_id));
        db_query("DELETE FROM {spider_fc_events_table} WHERE calendar = :calendar", array(':calendar' => $cal_id));
        drupal_set_message(t('Selected calendars successfully deleted.'), 'status', FALSE);
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check a calendar.'), 'warning', FALSE);
    }
  }
}

/**
 * Delete calendar.
 */
function spider_fc_delete_calendar() {
  if (isset($_GET['cal_id'])) {
    $cal_id = check_plain($_GET['cal_id']);
  }
  db_query("DELETE FROM {spider_fc_calendar_table} WHERE id = :id", array(':id' => $cal_id));
  db_query("DELETE FROM {spider_fc_events_table} WHERE calendar = :calendar", array(':calendar' => $cal_id));
  drupal_goto(url('admin/settings/spider_fc', array('absolute' => TRUE)));
  drupal_set_message(t('Calendar successfully deleted.'), 'status', FALSE);
}

/**
 * Add a new calendar.
 */
function spider_fc_add_calendar() {
  $form = array();
  $form['cal_title'] = array(
    '#prefix' => '<p style="font-size:20px; font-weight:bold;">' . t('Create a new calendar') . '</p>',
    '#type' => 'textfield',
    '#title' => t('Title'),
    '#required' => TRUE,
    '#size' => 20,
  );
  $form['cal_published'] = array(
    '#type' => 'radios',
    '#title' => t('Published'),
    '#default_value' => 1,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['cal_submit'] = array(
    '#type' => 'submit',
    '#value' => t('Save'),
    '#submit' => array('spider_fc_cal_save'),
  );
  $form['cal_apply'] = array(
    '#type' => 'submit',
    '#value' => t('Apply'),
    '#submit' => array('spider_fc_cal_apply'),
  );
  $form['cal_cancel'] = array(
    '#type' => 'submit',
    '#value' => t('Cancel'),
    '#attributes' => array('onclick' => 'document.getElementById("edit-cal-title").setAttribute("style", "color:rgba(255, 0, 0, 0)");document.getElementById("edit-cal-title").setAttribute("value", "cancel");'),
    '#submit' => array('spider_fc_cal_new_cancel'),
  );
  return $form;
}

/**
 * Save a new calendar.
 */
function spider_fc_cal_save($form, &$form_state) {
  $count = db_query("SELECT COUNT(*) FROM {spider_fc_calendar_table}")->fetchField();
  if ($count >= 1) {
    drupal_set_message(t('To add more than one calendar, download the full version on') . ' ' . l(t('drupal.org.'), 'http://drupal.org/project/flash-calendar'), 'error', FALSE);
    $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
    return;
  }
  db_insert('spider_fc_calendar_table')
    ->fields(array(
      'title' => $form_state['values']['cal_title'],
      'published' => $form_state['values']['cal_published'],
      ))
    ->execute();
  $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
  drupal_set_message(t('Your calendar successfully saved.'), 'status', FALSE);
}

/**
 * Apply a new calendar.
 */
function spider_fc_cal_apply($form, &$form_state) {
  $count = db_query("SELECT COUNT(*) FROM {spider_fc_calendar_table}")->fetchField();
  if ($count >= 1) {
    drupal_set_message(t('To add more than one calendar, download the full version on') . ' ' . l(t('drupal.org.'), 'http://drupal.org/project/flash-calendar'), 'error', FALSE);
    $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
    return;
  }
  db_insert('spider_fc_calendar_table')
    ->fields(array(
      'title' => $form_state['values']['cal_title'],
      'published' => $form_state['values']['cal_published'],
      ))
    ->execute();
  $id = db_query("SELECT MAX(id) FROM {spider_fc_calendar_table}")->fetchField();
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/edit', array('query' => array('cal_id' => $id), 'absolute' => TRUE));
  drupal_set_message(t('Your calendar successfully saved.'), 'status', FALSE);
}

/**
 * Cancel a new calendar save.
 */
function spider_fc_cal_new_cancel($form, &$form_state) { 
  $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
}

/**
 * Edit calendar.
 */
function spider_fc_edit_calendar() {
  $form = array();
  if (isset($_GET['cal_id'])) {
    $id = check_plain($_GET['cal_id']);
  }
  $cal = db_query("SELECT * FROM {spider_fc_calendar_table} WHERE id=:id", array(':id' => $id))->fetchObject();
  $form['cal_title'] = array(
    '#prefix' => '<p style="font-size:20px; font-weight:bold;">' . t('Edit calendar') . ' ' . $cal->title . '</p>',
    '#type' => 'textfield',
    '#title' => t('Title'),
    '#required' => TRUE,
    '#default_value' => $cal->title,
    '#size' => 20,
  );
  $form['cal_published'] = array(
    '#type' => 'radios',
    '#title' => t('Published'),
    '#default_value' => $cal->published,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['cal_submit'] = array(
    '#type' => 'submit',
    '#value' => t('Save'),
    '#submit' => array('spider_fc_cal_update'),
  );
  $form['cal_apply'] = array(
    '#type' => 'submit',
    '#value' => t('Apply'),
    '#submit' => array('spider_fc_cal_update_apply'),
  );
  $form['cal_cancel'] = array(
    '#type' => 'submit',
    '#value' => t('Cancel'),
    '#attributes' => array('onclick' => 'document.getElementById("edit-cal-title").setAttribute("style", "color:rgba(255, 0, 0, 0)");document.getElementById("edit-cal-title").setAttribute("value", "cancel");'),
    '#submit' => array('spider_fc_cal_update_cancel'),
  );
  return $form;
}

/**
 * Update the calendar.
 */
function spider_fc_cal_update($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $id = check_plain($_GET['cal_id']);
  }
  db_query("UPDATE {spider_fc_calendar_table} SET title=:title,published=:published WHERE id=:id", array(
    ':title' => $form_state['values']['cal_title'],
    ':published' => $form_state['values']['cal_published'],
    ':id' => $id,
    ));
  $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
  drupal_set_message(t('Your calendar successfully updated.'), 'status', FALSE);
}

/**
 * Apply updated calendar.
 */
function spider_fc_cal_update_apply($form, &$form_state) {
  if (isset($_GET['cal_id'])) {
    $id = check_plain($_GET['cal_id']);
  }
  db_query("UPDATE {spider_fc_calendar_table} SET title=:title,published=:published WHERE id=:id", array(
    ':title' => $form_state['values']['cal_title'],
    ':published' => $form_state['values']['cal_published'],
    ':id' => $id,
    ));
  $form_state['redirect'] = url('admin/settings/spider_fc/calendar/edit', array('query' => array('cal_id' => $id), 'absolute' => TRUE));
  drupal_set_message(t('Your calendar successfully updated.'), 'status', FALSE);
}

/**
 * Cancel the calendar save.
 */
function spider_fc_cal_update_cancel($form, &$form_state) {
  $form_state['redirect'] = url('admin/settings/spider_fc', array('absolute' => TRUE));
}
