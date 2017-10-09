<?php
/**
 * @file
 *
 * Calendars themes.
 */

/**
 * Menu loader callback. Load a Spider FC themes.
 */
function spider_fc_calendar_theme() {
  $form['fieldset_theme_buttons'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
  );
  $form['fieldset_theme_buttons']['delete_themes'] = array(
    '#type' => 'submit',
    '#submit' => array('spider_fc_delete_themes'),
    '#value' => t('Delete'),
    '#attributes' => array('onclick' => 'if (!confirm(Drupal.t("Do you want to delete selected themes?"))) {return false;}'),
  );
  $form['fieldset_theme_buttons']['new_theme'] = array(
    '#prefix' => l(t('New'), url('admin/settings/spider_fc/themes/new', array('absolute' => TRUE))),
  );
  $form['fieldset_themes'] = array(
    '#type' => 'fieldset',
    '#attributes' => array('class' => array('fieldset')),
    '#title' => t('Themes'),
  );
  $header = array(
    'id' => array('data' => t('ID'), 'field' => 'n.id'),
    'title' => array('data' => t('Title'), 'field' => 'n.title'),
    'delete' => array('data' => t('Delete')),
  );
  $options = array();
  $theme_ids = db_select('spider_fc_theme_table', 'n')
    ->fields('n', array('id'))
    ->extend('TableSort')
    ->orderByHeader($header)
    ->extend('PagerDefault')
    ->limit(20)
    ->execute()
    ->fetchCol();
  foreach ($theme_ids as $theme_id) {
    $row = db_query('SELECT * FROM {spider_fc_theme_table} WHERE id=:id', array(':id' => $theme_id))->fetchObject();
    $options[$row->id] = array(
      'id' => $row->id,
      'title' => array(
        'data' => array(
          '#type' => 'link',
          '#title' => $row->title,
          '#href' => url('admin/settings/spider_fc/themes/new', array('query' => array('theme_id' => $theme_id), 'absolute' => TRUE)),
        ),
      ),
    );
    if ($row->default_settings != 1 ) {
      $options[$row->id]['delete'] = array(
        'data' => array(
          '#type' => 'link',
          '#title' => t('Delete'),
          '#href' => url('admin/settings/spider_fc/themes/delete', array('query' => array('theme_id' => $theme_id), 'absolute' => TRUE)),
        ),
      );
    }
    else {
      $options[$row->id]['delete'] = '';
    }
  }
  $form['fieldset_themes']['themes_table'] = array(
    '#type' => 'tableselect',
    '#header' => $header,
    '#options' => $options,
    '#empty' => t('No theme available.'),
    '#suffix' => theme('pager', array('tags' => array())),
  );
  foreach ($theme_ids as $theme_id) {
    if ($theme_id <= 10) {
      $form['fieldset_themes']['themes_table'][$theme_id]['#disabled'] = TRUE;
    }
  }
  return $form;
}

/**
 * Delete selected themes.
 */
function spider_fc_delete_themes($form, &$form_state) {
  if (db_query("SELECT id FROM {spider_fc_theme_table}")) {
    $theme_ids_col = db_query("SELECT id FROM {spider_fc_theme_table}")->fetchCol();
    $flag = FALSE;
    foreach ($theme_ids_col as $theme_id) {
      if (isset($_POST['themes_table'][$theme_id])) {
        $flag = TRUE;
        db_query("DELETE FROM {spider_fc_theme_table} WHERE id=:id", array(':id' => $theme_id));
        drupal_set_message(t('Selected themes successfully deleted.'), 'status', FALSE);
      }
    }
    if ($flag == FALSE) {
      drupal_set_message(t('You must check a theme.'), 'warning', FALSE);
    }
  }
}

/**
 * Delete theme.
 */
function spider_fc_delete_theme() {
  if (isset($_GET['theme_id'])) {
    $theme_id = check_plain($_GET['theme_id']);
  }
  db_query("DELETE FROM {spider_fc_theme_table} WHERE id=:id", array(':id' => $theme_id));
  drupal_goto(url('admin/settings/spider_fc/themes', array('absolute' => TRUE)));
  drupal_set_message(t('Theme successfully deleted.'), 'status', FALSE);
}

/**
 * Add or edit theme.
 */
function spider_fc_add_theme() {
  drupal_add_css(drupal_get_path('module', 'spider_fc') . '/css/spider_fc_event_filedset.css');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_theme_reset.js');
  
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_jquery-1.7.1.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_jquery.ui.core.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_jquery.ui.widget.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_jquery.ui.mouse.js');
  drupal_add_js(drupal_get_path('module', 'spider_fc') . '/js/spider_fc_jquery.ui.slider.js');
  drupal_add_css(drupal_get_path('module', 'spider_fc') . '/css/spider_fc_parseTheme.css');
  drupal_add_css(drupal_get_path('module', 'spider_fc') . '/css/spider_fc_jquery-ui.css');

  if (!file_exists("sites/all/libraries/jscolor/jscolor.js")) {
    drupal_set_message(t("Download 'jscolor' library from <a href='http://jscolor.com/release/jscolor-1.4.0.zip'>http://jscolor.com/release/jscolor-1.4.0.zip</a> and extract it to sites/all/libraries/jscolor directory.<br />"), 'warning', FALSE);
  }
  else {
    drupal_add_js('sites/all/libraries/jscolor/jscolor.js');
  }
  if (isset($_GET['theme_id'])) {
    $theme_id = check_plain($_GET['theme_id']);
    $title_theme = '';
  }
  else {
    $theme_id = 1;
    $title_theme = 'new ';
  }
  $themeinf = db_query("SELECT * FROM {spider_fc_theme_table} WHERE id=:id", array(':id' => $theme_id))->fetchObject();
  $title_theme = $title_theme . $themeinf->title;
  $startwithmonday_theme = $themeinf->startWithMonday;
  $dateformat_theme = str_replace('&#37;', '%', $themeinf->dateFormat);
  $dateformatshort_theme = str_replace('&#37;', '%', $themeinf->dateFormatShort);
  $time_theme = $themeinf->time;
  $appmaxwidth_theme = $themeinf->appMaxWidth;
  $appmaxheight_theme = $themeinf->appMaxHeight;
  $appminwidth_theme = $themeinf->appMinWidth;
  $appminheight_theme = $themeinf->appMinHeight;
  $startviewsize_theme = $themeinf->startViewSize;
  $startviewstate_theme = $themeinf->startViewState;
  $bgcolors1_theme = $themeinf->bgColors1;
  $bgcolors2_theme = $themeinf->bgColors2;
  $bgstrokecolor_theme = $themeinf->bgStrokeColor;
  $bgcornerradius_theme = $themeinf->bgCornerRadius;
  $headerheight_theme = $themeinf->headerHeight;
  $headerpadding_theme = $themeinf->headerPadding;
  $headerbgcolors1_theme = $themeinf->headerBgColors1;
  $headerbgcolors2_theme = $themeinf->headerBgColors2;
  $headerbgstrokecolor_theme = $themeinf->headerBgStrokeColor;
  $headercontentcolor_theme = $themeinf->headerContentColor;
  $headercontentstrokecolor_theme = $themeinf->headerContentStrokeColor;
  $headerfontsize_theme = $themeinf->headerFontSize;
  $daysnamescolor_theme = $themeinf->daysNamesColor;
  $daysnamesfontsize_theme = $themeinf->daysNamesFontSize;
  $datesbgcolors1_theme = $themeinf->datesBgColors1;
  $datesbgcolors2_theme = $themeinf->datesBgColors2;
  $datesbgstrokecolor_theme = $themeinf->datesBgStrokeColor;
  $priority0color_theme = $themeinf->priority0Color;
  $priority1color_theme = $themeinf->priority1Color;
  $priority2color_theme = $themeinf->priority2Color;
  $priority3color_theme = $themeinf->priority3Color;
  $datefontsize_theme = $themeinf->dateFontSize;
  $datecolor_theme = $themeinf->dateColor;
  $datestrokecolor_theme = $themeinf->dateStrokeColor;
  $showdateeventscount_theme = $themeinf->showDateEventsCount;
  $dateeventscountfontsize_theme = $themeinf->dateEventsCountFontSize;
  $dateeventscountcolor_theme = $themeinf->dateEventsCountColor;
  $eventslistheaderheight_theme = $themeinf->eventsListHeaderHeight;
  $eventslistheaderstrokecolor_theme = $themeinf->eventsListHeaderStrokeColor;
  $eventslistheaderbgcolors1_theme = $themeinf->eventsListHeaderbgColors1;
  $eventslistheaderbgcolors2_theme = $themeinf->eventsListHeaderbgColors2;
  $eventslistheadercolor_theme = $themeinf->eventsListHeaderColor;
  $eventslistheaderfontsize_theme = $themeinf->eventsListHeaderFontSize;
  $eventheaderheight_theme = $themeinf->eventHeaderHeight;
  $eventheaderfontsize_theme = $themeinf->eventHeaderFontSize;
  $eventheadercolor_theme = $themeinf->eventHeaderColor;
  $eventcontentbgcolors1_theme = $themeinf->eventContentBgColors1;
  $eventcontentbgcolors2_theme = $themeinf->eventContentBgColors2;
  $eventcontentdatesfontsize_theme = $themeinf->eventContentDatesFontSize;
  $eventcontentdatescolor_theme = $themeinf->eventContentDatesColor;
  $eventcontentdescriptionfontsize_theme = $themeinf->eventContentDescriptionFontSize;
  $eventcontentdescriptioncolor_theme = $themeinf->eventContentDescriptionColor;
  $mediadefaultautoplay_theme = $themeinf->mediaDefaultAutoplay;
  $mediascaletype_theme = $themeinf->mediaScaleType;
  $mediashowduration_theme = $themeinf->mediaShowDuration;
  $videodefaultvolume_theme = $themeinf->videoDefaultVolume;
  $videoautoplay_theme = $themeinf->videoAutoplay;
  $mediabgcolor_theme = $themeinf->mediaBgColor;
  $mediactrlsbgcolor_theme = $themeinf->mediaCtrlsBgColor;
  $mediactrlsbgalpha_theme = $themeinf->mediaCtrlsBgAlpha;
  $mediactrlscolor_theme = $themeinf->mediaCtrlsColor;
  $mediactrlsalpha_theme = $themeinf->mediaCtrlsAlpha;
  $footerheight_theme = $themeinf->footerHeight;
  $footercolor_theme = $themeinf->footerColor;
  $default_theme = $themeinf->default_settings;

  $form = array();
  if ($default_theme != '1' || !isset($_GET['theme_id'])) {
    $diable_title_field = FALSE;
    $themes = db_query("SELECT id,title FROM {spider_fc_theme_table} WHERE default_settings=:default_settings ORDER BY title", array(':default_settings' => 1))->fetchAllKeyed();
    $themes[0] = '';
    $form['theme_select'] = array(
      '#type' => 'fieldset',
      '#attributes' => array(
        'class' => array('spider_fc_theme_select_fieldset'),
        'id' => 'fieldset_theme_select',
      ),
    );
    $form['theme_select']['default_themes'] = array(
      '#type' => 'select',
      '#title' => t('Inherit from theme'),
      '#options' => $themes,
      '#attributes' => array('onchange' => 'spider_fc_set_theme();'),
      '#default_value' => 0,
    );
  }
  else {
    $diable_title_field = TRUE;
  }
  $form['theme_general'] = array(
    '#type' => 'fieldset',
    '#title' => t('General Parameters'),
    '#attributes' => array(
      'class' => array('spider_fc_theme_general_fielset'),
      'id' => 'theme_general_par',
    ),
  );
  $form['theme_general']['theme_title'] = array(
    '#type' => 'textfield',
    '#title' => t('Title'),
    '#required' => TRUE,
    '#default_value' => $title_theme,
    '#disabled' => $diable_title_field,
    '#size' => 25,
  );
  $form['theme_general']['week_start_day'] = array(
    '#type' => 'radios',
    '#title' => t('Start With Monday'),
    '#default_value' => $startwithmonday_theme,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['theme_general']['date_format'] = array(
    '#type' => 'textfield',
    '#title' => t('Date Format'),
    '#default_value' => $dateformat_theme,
    '#size' => 25,
  );
  $form['theme_general']['date_format_format'] = array(
    '#type' => 'textfield',
    '#title' => t('Date Format Short'),
    '#default_value' => $dateformatshort_theme,
    '#size' => 25,
  );
  $form['theme_general']['time_theme'] = array(
    '#type' => 'radios',
    '#title' => t('Time 12 Hours'),
    '#default_value' => $time_theme,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['theme_general']['appmaxwidth_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Width in the large mode'),
    '#default_value' => $appmaxwidth_theme,
    '#size' => 25,
  );
  $form['theme_general']['appmaxheight_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Height in the large mode'),
    '#default_value' => $appmaxheight_theme,
    '#size' => 25,
  ); 
  $form['theme_general']['appminwidth_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Width in the small mode'),
    '#default_value' => $appminwidth_theme,
    '#size' => 25,
  );
  $form['theme_general']['appminheight_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Height in the small mode'),
    '#default_value' => $appminheight_theme,
    '#size' => 25,
  );
  $form['theme_general']['startviewsize_theme'] = array(
    '#type' => 'select',
    '#title' => t('Size mode at start'),
    '#options' => array(
      'viewSizeMax' => t('Max size'),
      'viewSizeMin' => t('Min size'),
    ),
    '#default_value' => $startviewsize_theme,
  );
  $form['theme_general']['startviewstate_theme'] = array(
    '#type' => 'select',
    '#title' => t('View mode at start'),
    '#options' => array(
      'viewStateDays' => t('Days'),
      'viewStateMonths' => t('Months'),
      'viewStateYears' => t('Years'),
    ),
    '#default_value' => $startviewstate_theme,
  );
  $form['theme_general']['bgcolors1_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Main background color (gradient)'),
    '#default_value' => $bgcolors1_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_general']['bgcolors2_theme'] = array(
    '#type' => 'textfield',
    '#default_value' => $bgcolors2_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_general']['bgstrokecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Main border color'),
    '#default_value' => $bgstrokecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_general']['bgcornerradius_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Main border radius'),
    '#default_value' => $bgcornerradius_theme,
    '#size' => 25,
  );
  if (isset($_GET['theme_id']) && $default_theme == 1) {
    $form['theme_general']['reset_button'] = array(
      '#prefix' => '<div id="reset_theme_id" onclick="spider_fc_reset_theme_' . $theme_id . '();" style="width:170px; height:35px; color:#ffffff; font-size:15px; background-repeat:no-repeat; background-image:url(\'' . base_path() . drupal_get_path('module', 'spider_fc') . '/images/reset_theme.png\')">
                      <p style="font-weight: bold; padding-left: 51px; padding-top: 7px; margin:0px;">' . t('Reset Theme') . '</p>
                    </div>',
    );
  }
  $form['theme_header'] = array(
    '#type' => 'fieldset',
    '#title' => t('Header Parameters'),
    '#attributes' => array(
      'class' => array('spider_fc_theme_body_fielset'),
      'id' => 'theme_body_par',
    ),
  );
  $form['theme_header']['headerheight_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header height'),
    '#default_value' => $headerheight_theme,
    '#size' => 25,
  );
  $form['theme_header']['headerpadding_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header padding'),
    '#default_value' => $headerpadding_theme,
    '#size' => 25,
  );
  $form['theme_header']['headerbgcolors1_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header background color (gradient)'),
    '#default_value' => $headerbgcolors1_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_header']['headerbgcolors2_theme'] = array(
    '#type' => 'textfield',
    '#default_value' => $headerbgcolors2_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_header']['headerbgstrokecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header border color'),
    '#default_value' => $headerbgstrokecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_header']['headercontentcolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header content color'),
    '#default_value' => $headercontentcolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_header']['headercontentstrokecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header content stroke color'),
    '#default_value' => $headercontentstrokecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_header']['headerfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Header content font size'),
    '#default_value' => $headerfontsize_theme,
    '#size' => 25,
  );
  $form['body_header'] = array(
    '#type' => 'fieldset',
    '#title' => t('Body Parameters'),
    '#attributes' => array(
      'class' => array('spider_fc_theme_header_fielset'),
      'id' => 'theme_header_par',
    ),
  );
  $form['body_header']['daysnamescolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Weekdays text color'),
    '#default_value' => $daysnamescolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['daysnamesfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Weekdays text font size'),
    '#default_value' => $daysnamesfontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['datesbgcolors1_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Days background color (gradient'),
    '#default_value' => $datesbgcolors1_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['datesbgcolors2_theme'] = array(
    '#type' => 'textfield',
    '#default_value' => $datesbgcolors2_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['datesbgstrokecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Cell border color'),
    '#default_value' => $datesbgstrokecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['priority0color_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Background color of a cell with event with no priority'),
    '#default_value' => $priority0color_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['priority1color_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Background color of a cell with event with low priority'),
    '#default_value' => $priority1color_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['priority2color_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Background color of a cell with event with medium priority'),
    '#default_value' => $priority2color_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['priority3color_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Background color of a cell with event with high priority'),
    '#default_value' => $priority3color_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['datefontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Cell content font size'),
    '#default_value' => $datefontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['datecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Cell content color'),
    '#default_value' => $datecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['datestrokecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Current day cell border color'),
    '#default_value' => $datestrokecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['showdateeventscount_theme'] = array(
    '#type' => 'radios',
    '#title' => t('Show number of events'),
    '#default_value' => $showdateeventscount_theme,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['body_header']['dateeventscountfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Number of events font size'),
    '#default_value' => $dateeventscountfontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['dateeventscountcolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Number of events color'),
    '#default_value' => $dateeventscountcolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventslistheaderheight_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Events list header height(px)'),
    '#default_value' => $eventslistheaderheight_theme,
    '#size' => 25,
  );
  $form['body_header']['eventslistheaderstrokecolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Events list header border color'),
    '#default_value' => $eventslistheaderstrokecolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventslistheaderbgcolors1_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Events list header background color (gradient)'),
    '#default_value' => $eventslistheaderbgcolors1_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventslistheaderbgcolors2_theme'] = array(
    '#type' => 'textfield',
    '#default_value' => $eventslistheaderbgcolors2_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventslistheadercolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Events list header content color'),
    '#default_value' => $eventslistheadercolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventslistheaderfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Events list header content font size'),
    '#default_value' => $eventslistheaderfontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['eventheaderheight_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event header height(px)'),
    '#default_value' => $eventheaderheight_theme,
    '#size' => 25,
  );
  $form['body_header']['eventheaderfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event header content font size'),
    '#default_value' => $eventheaderfontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['eventheadercolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event header content color'),
    '#default_value' => $eventheadercolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventcontentbgcolors1_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event content background color (gradient)'),
    '#default_value' => $eventcontentbgcolors1_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventcontentbgcolors2_theme'] = array(
    '#type' => 'textfield',
    '#default_value' => $eventcontentbgcolors2_theme,
    '#size' => 10,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventcontentdatesfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event content dates font size'),
    '#default_value' => $eventcontentdatesfontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['eventcontentdatescolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event content dates color'),
    '#default_value' => $eventcontentdatescolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['eventcontentdescriptionfontsize_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event content description font size'),
    '#default_value' => $eventcontentdescriptionfontsize_theme,
    '#size' => 25,
  );
  $form['body_header']['eventcontentdescriptioncolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Event content description color'),
    '#default_value' => $eventcontentdescriptioncolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['body_header']['footerheight_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Footer height(px)'),
    '#default_value' => $footerheight_theme,
    '#size' => 25,
  );
  $form['body_header']['footercolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Footer content color'),
    '#default_value' => $footercolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  drupal_add_js('jQuery(function() {
    spider_fc_change_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1");
    spider_fc_change_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2");
    spider_fc_change_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3");
    });', array('type' => 'inline', 'scope' => 'footer'));
  $form['theme_media'] = array(
    '#type' => 'fieldset',
    '#title' => t('Media  Parameters'),
    '#attributes' => array(
      'class' => array('spider_fc_theme_popup_fielset'),
      'id' => 'theme_popup_par',
    ),
  );
  $form['theme_media']['mediadefaultautoplay_theme'] = array(
    '#type' => 'radios',
    '#title' => t('Media autoplay at start'),
    '#default_value' => $mediadefaultautoplay_theme,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['theme_media']['mediascaletype_theme'] = array(
    '#type' => 'select',
    '#title' => t('Media scale type'),
    '#options' => array(
      'scaleTypeTouchFromInside' => t('Inside'),
      'scaleTypeTouchFromOutside' => t('Outside'),
      'scaleTypeTouchFromStratch' => t('Stratch'),
    ),
    '#default_value' => $mediascaletype_theme,
  );
  $form['theme_media']['mediashowduration_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Media change duration'),
    '#default_value' => $mediashowduration_theme,
    '#size' => 25,
  );
  $form['theme_media']['videodefaultvolume_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Video default volume'),
    '#default_value' => $videodefaultvolume_theme,
    '#size' => 3,
    '#attributes' => array('id' => 'SpiderFC_videoDefaultVolume'),
    '#suffix' => '% <div id="slider-videoDefaultVolume3" class="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all" style="width:135px"></div>',
  );
  $form['theme_media']['videoautoplay_theme'] = array(
    '#type' => 'radios',
    '#title' => t('Video Autoplay in media slider'),
    '#default_value' => $videoautoplay_theme,
    '#options' => array('1' => t('Yes'), '0' => t('No')),
  );
  $form['theme_media']['mediabgcolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Media background color'),
    '#default_value' => $mediabgcolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_media']['mediactrlsbgcolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Media control buttons background color'),
    '#default_value' => $mediactrlsbgcolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_media']['mediactrlsbgalpha_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Media control buttons background transparency'),
    '#default_value' => $mediactrlsbgalpha_theme,
    '#size' => 3,
    '#attributes' => array('id' => 'SpiderFC_mediaCtrlsBgAlpha'),
    '#suffix' => '% <div id="slider-videoDefaultVolume2" class="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all" style="width:135px"></div>',
  );
  $form['theme_media']['mediactrlscolor_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Media control buttons color'),
    '#default_value' => $mediactrlscolor_theme,
    '#size' => 25,
    '#attributes' => array('class' => array('color')),
  );
  $form['theme_media']['mediactrlsalpha_theme'] = array(
    '#type' => 'textfield',
    '#title' => t('Media control buttons transparency'),
    '#default_value' => $mediactrlsalpha_theme,
    '#size' => 3,
    '#attributes' => array('id' => 'SpiderFC_mediaCtrlsAlpha'),
    '#suffix' => '% <div id="slider-videoDefaultVolume1" class="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all" style="width:135px"></div>',
  );
  $form['theme_save'] = array(
    '#type' => 'submit',
    '#prefix' => '<div style="float:left; bottom:0px; clear:left;">',
    '#value' => t('Save'),
    '#submit' => array('spider_fc_theme_save'),
  );
  $form['theme_apply'] = array(
    '#type' => 'submit',
    '#value' => t('Apply'),
    '#submit' => array('spider_fc_theme_apply'),
  );
  $form['theme_cancel'] = array(
    '#type' => 'submit',
    '#value' => t('Cancel'),
    '#submit' => array('spider_fc_theme_cancel'),
    '#suffix' => '</div>',
  );
  return $form;
}

/**
 * Save theme.
 */
function spider_fc_theme_save($form, &$form_state) {
  if (isset($_GET['theme_id'])) {
    $theme_id = check_plain($_GET['theme_id']);
    db_query("UPDATE {spider_fc_theme_table} SET
        title= :title,
        startWithMonday= :startWithMonday,
        dateFormat= :dateFormat,
        dateFormatShort= :dateFormatShort,
        time= :time,
        appMaxWidth= :appMaxWidth,
        appMaxHeight= :appMaxHeight,
        appMinWidth= :appMinWidth,
        appMinHeight= :appMinHeight,
        startViewSize= :startViewSize,
        startViewState= :startViewState,
        bgColors1= :bgColors1,
        bgColors2= :bgColors2,
        bgStrokeColor= :bgStrokeColor,
        bgCornerRadius= :bgCornerRadius,
        headerHeight= :headerHeight,
        headerPadding= :headerPadding,
        headerBgColors1= :headerBgColors1,
        headerBgColors2= :headerBgColors2,
        headerBgStrokeColor= :headerBgStrokeColor,
        headerContentColor= :headerContentColor,
        headerContentStrokeColor= :headerContentStrokeColor,
        headerFontSize= :headerFontSize,
        daysNamesColor= :daysNamesColor,
        daysNamesFontSize= :daysNamesFontSize,
        datesBgColors1= :datesBgColors1,
        datesBgColors2= :datesBgColors2,
        datesBgStrokeColor= :datesBgStrokeColor,
        priority0Color= :priority0Color,
        priority1Color= :priority1Color,
        priority2Color= :priority2Color,
        priority3Color= :priority3Color,
        dateFontSize= :dateFontSize,
        dateColor= :dateColor,
        dateStrokeColor= :dateStrokeColor,
        showDateEventsCount= :showDateEventsCount,
        dateEventsCountFontSize= :dateEventsCountFontSize,
        dateEventsCountColor= :dateEventsCountColor,
        eventsListHeaderHeight= :eventsListHeaderHeight,
        eventsListHeaderStrokeColor= :eventsListHeaderStrokeColor,
        eventsListHeaderbgColors1= :eventsListHeaderbgColors1,
        eventsListHeaderbgColors2= :eventsListHeaderbgColors2,
        eventsListHeaderColor= :eventsListHeaderColor,
        eventsListHeaderFontSize= :eventsListHeaderFontSize,
        eventHeaderHeight= :eventHeaderHeight,
        eventHeaderFontSize= :eventHeaderFontSize,
        eventHeaderColor= :eventHeaderColor,
        eventContentBgColors1= :eventContentBgColors1,
        eventContentBgColors2= :eventContentBgColors2,
        eventContentDatesFontSize= :eventContentDatesFontSize,
        eventContentDatesColor= :eventContentDatesColor,
        eventContentDescriptionFontSize= :eventContentDescriptionFontSize,
        eventContentDescriptionColor= :eventContentDescriptionColor,
        footerHeight= :footerHeight,
        footerColor= :footerColor,
        mediaDefaultAutoplay= :mediaDefaultAutoplay,
        mediaScaleType= :mediaScaleType,
        mediaShowDuration= :mediaShowDuration,
        videoDefaultVolume= :videoDefaultVolume,
        videoAutoplay= :videoAutoplay,
        mediaBgColor= :mediaBgColor,
        mediaCtrlsBgColor= :mediaCtrlsBgColor,
        mediaCtrlsBgAlpha= :mediaCtrlsBgAlpha,
        mediaCtrlsColor= :mediaCtrlsColor,
        mediaCtrlsAlpha= :mediaCtrlsAlpha
        WHERE id = :id", array(
          ':title' => $form_state['values']['theme_title'],
          ':startWithMonday' => $form_state['values']['week_start_day'],
          ':dateFormat' => $form_state['values']['date_format'],
          ':dateFormatShort' => $form_state['values']['date_format_format'],
          ':time' => $form_state['values']['time_theme'],
          ':appMaxWidth' => $form_state['values']['appmaxwidth_theme'],
          ':appMaxHeight' => $form_state['values']['appmaxheight_theme'],
          ':appMinWidth' => $form_state['values']['appminwidth_theme'],
          ':appMinHeight' => $form_state['values']['appminheight_theme'],
          ':startViewSize' => $form_state['values']['startviewsize_theme'],
          ':startViewState' => $form_state['values']['startviewstate_theme'],
          ':bgColors1' => $form_state['values']['bgcolors1_theme'],
          ':bgColors2' => $form_state['values']['bgcolors2_theme'],
          ':bgStrokeColor' => $form_state['values']['bgstrokecolor_theme'],
          ':bgCornerRadius' => $form_state['values']['bgcornerradius_theme'],
          ':headerHeight' => $form_state['values']['headerheight_theme'],
          ':headerPadding' => $form_state['values']['headerpadding_theme'],
          ':headerBgColors1' => $form_state['values']['headerbgcolors1_theme'],
          ':headerBgColors2' => $form_state['values']['headerbgcolors2_theme'],
          ':headerBgStrokeColor' => $form_state['values']['headerbgstrokecolor_theme'],
          ':headerContentColor' => $form_state['values']['headercontentcolor_theme'],
          ':headerContentStrokeColor' => $form_state['values']['headercontentstrokecolor_theme'],
          ':headerFontSize' => $form_state['values']['headerfontsize_theme'],
          ':daysNamesColor' => $form_state['values']['daysnamescolor_theme'],
          ':daysNamesFontSize' => $form_state['values']['daysnamesfontsize_theme'],
          ':datesBgColors1' => $form_state['values']['datesbgcolors1_theme'],
          ':datesBgColors2' => $form_state['values']['datesbgcolors2_theme'],
          ':datesBgStrokeColor' => $form_state['values']['datesbgstrokecolor_theme'],
          ':priority0Color' => $form_state['values']['priority0color_theme'],
          ':priority1Color' => $form_state['values']['priority1color_theme'],
          ':priority2Color' => $form_state['values']['priority2color_theme'],
          ':priority3Color' => $form_state['values']['priority3color_theme'],
          ':dateFontSize' => $form_state['values']['datefontsize_theme'],
          ':dateColor' => $form_state['values']['datecolor_theme'],
          ':dateStrokeColor' => $form_state['values']['datestrokecolor_theme'],
          ':showDateEventsCount' => $form_state['values']['showdateeventscount_theme'],
          ':dateEventsCountFontSize' => $form_state['values']['dateeventscountfontsize_theme'],
          ':dateEventsCountColor' => $form_state['values']['dateeventscountcolor_theme'],
          ':eventsListHeaderHeight' => $form_state['values']['eventslistheaderheight_theme'],
          ':eventsListHeaderStrokeColor' => $form_state['values']['eventslistheaderstrokecolor_theme'],
          ':eventsListHeaderbgColors1' => $form_state['values']['eventslistheaderbgcolors1_theme'],
          ':eventsListHeaderbgColors2' => $form_state['values']['eventslistheaderbgcolors2_theme'],
          ':eventsListHeaderColor' => $form_state['values']['eventslistheadercolor_theme'],
          ':eventsListHeaderFontSize' => $form_state['values']['eventslistheaderfontsize_theme'],
          ':eventHeaderHeight' => $form_state['values']['eventheaderheight_theme'],
          ':eventHeaderFontSize' => $form_state['values']['eventheaderfontsize_theme'],
          ':eventHeaderColor' => $form_state['values']['eventheadercolor_theme'],
          ':eventContentBgColors1' => $form_state['values']['eventcontentbgcolors1_theme'],
          ':eventContentBgColors2' => $form_state['values']['eventcontentbgcolors2_theme'],
          ':eventContentDatesFontSize' => $form_state['values']['eventcontentdatesfontsize_theme'],
          ':eventContentDatesColor' => $form_state['values']['eventcontentdatescolor_theme'],
          ':eventContentDescriptionFontSize' => $form_state['values']['eventcontentdescriptionfontsize_theme'],
          ':eventContentDescriptionColor' => $form_state['values']['eventcontentdescriptioncolor_theme'],
          ':footerHeight' => $form_state['values']['footerheight_theme'],
          ':footerColor' => $form_state['values']['footercolor_theme'],
          ':mediaDefaultAutoplay' => $form_state['values']['mediadefaultautoplay_theme'],
          ':mediaScaleType' => $form_state['values']['mediascaletype_theme'],
          ':mediaShowDuration' => $form_state['values']['mediashowduration_theme'],
          ':videoDefaultVolume' => $form_state['values']['videodefaultvolume_theme'],
          ':videoAutoplay' => $form_state['values']['videoautoplay_theme'],
          ':mediaBgColor' => $form_state['values']['mediabgcolor_theme'],
          ':mediaCtrlsBgColor' => $form_state['values']['mediactrlsbgcolor_theme'],
          ':mediaCtrlsBgAlpha' => $form_state['values']['mediactrlsbgalpha_theme'],
          ':mediaCtrlsColor' => $form_state['values']['mediactrlscolor_theme'],
          ':mediaCtrlsAlpha' => $form_state['values']['mediactrlsalpha_theme'],
          ':id' => $theme_id,
        ));
    drupal_set_message(t('Your theme successfully updated.'), 'status', FALSE);
  }
  else {
    db_insert('spider_fc_theme_table')
      ->fields(array(
        'title' => $form_state['values']['theme_title'],
        'startWithMonday' => $form_state['values']['week_start_day'],
        'dateFormat' => $form_state['values']['date_format'],
        'dateFormatShort' => $form_state['values']['date_format_format'],
        'time' => $form_state['values']['time_theme'],
        'appMaxWidth' => $form_state['values']['appmaxwidth_theme'],
        'appMaxHeight' => $form_state['values']['appmaxheight_theme'],
        'appMinWidth' => $form_state['values']['appminwidth_theme'],
        'appMinHeight' => $form_state['values']['appminheight_theme'],
        'startViewSize' => $form_state['values']['startviewsize_theme'],
        'startViewState' => $form_state['values']['startviewstate_theme'],
        'bgColors1' => $form_state['values']['bgcolors1_theme'],
        'bgColors2' => $form_state['values']['bgcolors2_theme'],
        'bgStrokeColor' => $form_state['values']['bgstrokecolor_theme'],
        'bgCornerRadius' => $form_state['values']['bgcornerradius_theme'],
        'headerHeight' => $form_state['values']['headerheight_theme'],
        'headerPadding' => $form_state['values']['headerpadding_theme'],
        'headerBgColors1' => $form_state['values']['headerbgcolors1_theme'],
        'headerBgColors2' => $form_state['values']['headerbgcolors2_theme'],
        'headerBgStrokeColor' => $form_state['values']['headerbgstrokecolor_theme'],
        'headerContentColor' => $form_state['values']['headercontentcolor_theme'],
        'headerContentStrokeColor' => $form_state['values']['headercontentstrokecolor_theme'],
        'headerFontSize' => $form_state['values']['headerfontsize_theme'],
        'daysNamesColor' => $form_state['values']['daysnamescolor_theme'],
        'daysNamesFontSize' => $form_state['values']['daysnamesfontsize_theme'],
        'datesBgColors1' => $form_state['values']['datesbgcolors1_theme'],
        'datesBgColors2' => $form_state['values']['datesbgcolors2_theme'],
        'datesBgStrokeColor' => $form_state['values']['datesbgstrokecolor_theme'],
        'priority0Color' => $form_state['values']['priority0color_theme'],
        'priority1Color' => $form_state['values']['priority1color_theme'],
        'priority2Color' => $form_state['values']['priority2color_theme'],
        'priority3Color' => $form_state['values']['priority3color_theme'],
        'dateFontSize' => $form_state['values']['datefontsize_theme'],
        'dateColor' => $form_state['values']['datecolor_theme'],
        'dateStrokeColor' => $form_state['values']['datestrokecolor_theme'],
        'showDateEventsCount' => $form_state['values']['showdateeventscount_theme'],
        'dateEventsCountFontSize' => $form_state['values']['dateeventscountfontsize_theme'],
        'dateEventsCountColor' => $form_state['values']['dateeventscountcolor_theme'],
        'eventsListHeaderHeight' => $form_state['values']['eventslistheaderheight_theme'],
        'eventsListHeaderStrokeColor' => $form_state['values']['eventslistheaderstrokecolor_theme'],
        'eventsListHeaderbgColors1' => $form_state['values']['eventslistheaderbgcolors1_theme'],
        'eventsListHeaderbgColors2' => $form_state['values']['eventslistheaderbgcolors2_theme'],
        'eventsListHeaderColor' => $form_state['values']['eventslistheadercolor_theme'],
        'eventsListHeaderFontSize' => $form_state['values']['eventslistheaderfontsize_theme'],
        'eventHeaderHeight' => $form_state['values']['eventheaderheight_theme'],
        'eventHeaderFontSize' => $form_state['values']['eventheaderfontsize_theme'],
        'eventHeaderColor' => $form_state['values']['eventheadercolor_theme'],
        'eventContentBgColors1' => $form_state['values']['eventcontentbgcolors1_theme'],
        'eventContentBgColors2' => $form_state['values']['eventcontentbgcolors2_theme'],
        'eventContentDatesFontSize' => $form_state['values']['eventcontentdatesfontsize_theme'],
        'eventContentDatesColor' => $form_state['values']['eventcontentdatescolor_theme'],
        'eventContentDescriptionFontSize' => $form_state['values']['eventcontentdescriptionfontsize_theme'],
        'eventContentDescriptionColor' => $form_state['values']['eventcontentdescriptioncolor_theme'],
        'mediaDefaultAutoplay' => $form_state['values']['mediadefaultautoplay_theme'],
        'mediaScaleType' => $form_state['values']['mediascaletype_theme'],
        'mediaShowDuration' => $form_state['values']['mediashowduration_theme'],
        'videoDefaultVolume' => $form_state['values']['videodefaultvolume_theme'],
        'videoAutoplay' => $form_state['values']['videoautoplay_theme'],
        'mediaBgColor' => $form_state['values']['mediabgcolor_theme'],
        'mediaCtrlsBgColor' => $form_state['values']['mediactrlsbgcolor_theme'],
        'mediaCtrlsBgAlpha' => $form_state['values']['mediactrlsbgalpha_theme'],
        'mediaCtrlsColor' => $form_state['values']['mediactrlscolor_theme'],
        'mediaCtrlsAlpha' => $form_state['values']['mediactrlsalpha_theme'],
        'footerHeight' => $form_state['values']['footerheight_theme'],
        'footerColor' => $form_state['values']['footercolor_theme'],
        'default_settings' => 0))
      ->execute();
    drupal_set_message(t('Your theme successfully saved.'), 'status', FALSE);
  }
  $form_state['redirect'] = url('admin/settings/spider_fc/themes', array('absolute' => TRUE));
}

/**
 * Apply theme.
 */
function spider_fc_theme_apply($form, &$form_state) {
  if (isset($_GET['theme_id'])) {
    $theme_id = check_plain($_GET['theme_id']);
    db_query("UPDATE {spider_fc_theme_table} SET
        title= :title,
        startWithMonday= :startWithMonday,
        dateFormat= :dateFormat,
        dateFormatShort= :dateFormatShort,
        time= :time,
        appMaxWidth= :appMaxWidth,
        appMaxHeight= :appMaxHeight,
        appMinWidth= :appMinWidth,
        appMinHeight= :appMinHeight,
        startViewSize= :startViewSize,
        startViewState= :startViewState,
        bgColors1= :bgColors1,
        bgColors2= :bgColors2,
        bgStrokeColor= :bgStrokeColor,
        bgCornerRadius= :bgCornerRadius,
        headerHeight= :headerHeight,
        headerPadding= :headerPadding,
        headerBgColors1= :headerBgColors1,
        headerBgColors2= :headerBgColors2,
        headerBgStrokeColor= :headerBgStrokeColor,
        headerContentColor= :headerContentColor,
        headerContentStrokeColor= :headerContentStrokeColor,
        headerFontSize= :headerFontSize,
        daysNamesColor= :daysNamesColor,
        daysNamesFontSize= :daysNamesFontSize,
        datesBgColors1= :datesBgColors1,
        datesBgColors2= :datesBgColors2,
        datesBgStrokeColor= :datesBgStrokeColor,
        priority0Color= :priority0Color,
        priority1Color= :priority1Color,
        priority2Color= :priority2Color,
        priority3Color= :priority3Color,
        dateFontSize= :dateFontSize,
        dateColor= :dateColor,
        dateStrokeColor= :dateStrokeColor,
        showDateEventsCount= :showDateEventsCount,
        dateEventsCountFontSize= :dateEventsCountFontSize,
        dateEventsCountColor= :dateEventsCountColor,
        eventsListHeaderHeight= :eventsListHeaderHeight,
        eventsListHeaderStrokeColor= :eventsListHeaderStrokeColor,
        eventsListHeaderbgColors1= :eventsListHeaderbgColors1,
        eventsListHeaderbgColors2= :eventsListHeaderbgColors2,
        eventsListHeaderColor= :eventsListHeaderColor,
        eventsListHeaderFontSize= :eventsListHeaderFontSize,
        eventHeaderHeight= :eventHeaderHeight,
        eventHeaderFontSize= :eventHeaderFontSize,
        eventHeaderColor= :eventHeaderColor,
        eventContentBgColors1= :eventContentBgColors1,
        eventContentBgColors2= :eventContentBgColors2,
        eventContentDatesFontSize= :eventContentDatesFontSize,
        eventContentDatesColor= :eventContentDatesColor,
        eventContentDescriptionFontSize= :eventContentDescriptionFontSize,
        eventContentDescriptionColor= :eventContentDescriptionColor,
        footerHeight= :footerHeight,
        footerColor= :footerColor,
        mediaDefaultAutoplay= :mediaDefaultAutoplay,
        mediaScaleType= :mediaScaleType,
        mediaShowDuration= :mediaShowDuration,
        videoDefaultVolume= :videoDefaultVolume,
        videoAutoplay= :videoAutoplay,
        mediaBgColor= :mediaBgColor,
        mediaCtrlsBgColor= :mediaCtrlsBgColor,
        mediaCtrlsBgAlpha= :mediaCtrlsBgAlpha,
        mediaCtrlsColor= :mediaCtrlsColor,
        mediaCtrlsAlpha= :mediaCtrlsAlpha
        WHERE id = :id", array(
          ':title' => $form_state['values']['theme_title'],
          ':startWithMonday' => $form_state['values']['week_start_day'],
          ':dateFormat' => $form_state['values']['date_format'],
          ':dateFormatShort' => $form_state['values']['date_format_format'],
          ':time' => $form_state['values']['time_theme'],
          ':appMaxWidth' => $form_state['values']['appmaxwidth_theme'],
          ':appMaxHeight' => $form_state['values']['appmaxheight_theme'],
          ':appMinWidth' => $form_state['values']['appminwidth_theme'],
          ':appMinHeight' => $form_state['values']['appminheight_theme'],
          ':startViewSize' => $form_state['values']['startviewsize_theme'],
          ':startViewState' => $form_state['values']['startviewstate_theme'],
          ':bgColors1' => $form_state['values']['bgcolors1_theme'],
          ':bgColors2' => $form_state['values']['bgcolors2_theme'],
          ':bgStrokeColor' => $form_state['values']['bgstrokecolor_theme'],
          ':bgCornerRadius' => $form_state['values']['bgcornerradius_theme'],
          ':headerHeight' => $form_state['values']['headerheight_theme'],
          ':headerPadding' => $form_state['values']['headerpadding_theme'],
          ':headerBgColors1' => $form_state['values']['headerbgcolors1_theme'],
          ':headerBgColors2' => $form_state['values']['headerbgcolors2_theme'],
          ':headerBgStrokeColor' => $form_state['values']['headerbgstrokecolor_theme'],
          ':headerContentColor' => $form_state['values']['headercontentcolor_theme'],
          ':headerContentStrokeColor' => $form_state['values']['headercontentstrokecolor_theme'],
          ':headerFontSize' => $form_state['values']['headerfontsize_theme'],
          ':daysNamesColor' => $form_state['values']['daysnamescolor_theme'],
          ':daysNamesFontSize' => $form_state['values']['daysnamesfontsize_theme'],
          ':datesBgColors1' => $form_state['values']['datesbgcolors1_theme'],
          ':datesBgColors2' => $form_state['values']['datesbgcolors2_theme'],
          ':datesBgStrokeColor' => $form_state['values']['datesbgstrokecolor_theme'],
          ':priority0Color' => $form_state['values']['priority0color_theme'],
          ':priority1Color' => $form_state['values']['priority1color_theme'],
          ':priority2Color' => $form_state['values']['priority2color_theme'],
          ':priority3Color' => $form_state['values']['priority3color_theme'],
          ':dateFontSize' => $form_state['values']['datefontsize_theme'],
          ':dateColor' => $form_state['values']['datecolor_theme'],
          ':dateStrokeColor' => $form_state['values']['datestrokecolor_theme'],
          ':showDateEventsCount' => $form_state['values']['showdateeventscount_theme'],
          ':dateEventsCountFontSize' => $form_state['values']['dateeventscountfontsize_theme'],
          ':dateEventsCountColor' => $form_state['values']['dateeventscountcolor_theme'],
          ':eventsListHeaderHeight' => $form_state['values']['eventslistheaderheight_theme'],
          ':eventsListHeaderStrokeColor' => $form_state['values']['eventslistheaderstrokecolor_theme'],
          ':eventsListHeaderbgColors1' => $form_state['values']['eventslistheaderbgcolors1_theme'],
          ':eventsListHeaderbgColors2' => $form_state['values']['eventslistheaderbgcolors2_theme'],
          ':eventsListHeaderColor' => $form_state['values']['eventslistheadercolor_theme'],
          ':eventsListHeaderFontSize' => $form_state['values']['eventslistheaderfontsize_theme'],
          ':eventHeaderHeight' => $form_state['values']['eventheaderheight_theme'],
          ':eventHeaderFontSize' => $form_state['values']['eventheaderfontsize_theme'],
          ':eventHeaderColor' => $form_state['values']['eventheadercolor_theme'],
          ':eventContentBgColors1' => $form_state['values']['eventcontentbgcolors1_theme'],
          ':eventContentBgColors2' => $form_state['values']['eventcontentbgcolors2_theme'],
          ':eventContentDatesFontSize' => $form_state['values']['eventcontentdatesfontsize_theme'],
          ':eventContentDatesColor' => $form_state['values']['eventcontentdatescolor_theme'],
          ':eventContentDescriptionFontSize' => $form_state['values']['eventcontentdescriptionfontsize_theme'],
          ':eventContentDescriptionColor' => $form_state['values']['eventcontentdescriptioncolor_theme'],
          ':footerHeight' => $form_state['values']['footerheight_theme'],
          ':footerColor' => $form_state['values']['footercolor_theme'],
          ':mediaDefaultAutoplay' => $form_state['values']['mediadefaultautoplay_theme'],
          ':mediaScaleType' => $form_state['values']['mediascaletype_theme'],
          ':mediaShowDuration' => $form_state['values']['mediashowduration_theme'],
          ':videoDefaultVolume' => $form_state['values']['videodefaultvolume_theme'],
          ':videoAutoplay' => $form_state['values']['videoautoplay_theme'],
          ':mediaBgColor' => $form_state['values']['mediabgcolor_theme'],
          ':mediaCtrlsBgColor' => $form_state['values']['mediactrlsbgcolor_theme'],
          ':mediaCtrlsBgAlpha' => $form_state['values']['mediactrlsbgalpha_theme'],
          ':mediaCtrlsColor' => $form_state['values']['mediactrlscolor_theme'],
          ':mediaCtrlsAlpha' => $form_state['values']['mediactrlsalpha_theme'],
          ':id' => $theme_id,
        ));
    drupal_set_message(t('Your theme successfully updated.'), 'status', FALSE);
  }
  else {
    db_insert('spider_fc_theme_table')
      ->fields(array(
        'title' => $form_state['values']['theme_title'],
        'startWithMonday' => $form_state['values']['week_start_day'],
        'dateFormat' => $form_state['values']['date_format'],
        'dateFormatShort' => $form_state['values']['date_format_format'],
        'time' => $form_state['values']['time_theme'],
        'appMaxWidth' => $form_state['values']['appmaxwidth_theme'],
        'appMaxHeight' => $form_state['values']['appmaxheight_theme'],
        'appMinWidth' => $form_state['values']['appminwidth_theme'],
        'appMinHeight' => $form_state['values']['appminheight_theme'],
        'startViewSize' => $form_state['values']['startviewsize_theme'],
        'startViewState' => $form_state['values']['startviewstate_theme'],
        'bgColors1' => $form_state['values']['bgcolors1_theme'],
        'bgColors2' => $form_state['values']['bgcolors2_theme'],
        'bgStrokeColor' => $form_state['values']['bgstrokecolor_theme'],
        'bgCornerRadius' => $form_state['values']['bgcornerradius_theme'],
        'headerHeight' => $form_state['values']['headerheight_theme'],
        'headerPadding' => $form_state['values']['headerpadding_theme'],
        'headerBgColors1' => $form_state['values']['headerbgcolors1_theme'],
        'headerBgColors2' => $form_state['values']['headerbgcolors2_theme'],
        'headerBgStrokeColor' => $form_state['values']['headerbgstrokecolor_theme'],
        'headerContentColor' => $form_state['values']['headercontentcolor_theme'],
        'headerContentStrokeColor' => $form_state['values']['headercontentstrokecolor_theme'],
        'headerFontSize' => $form_state['values']['headerfontsize_theme'],
        'daysNamesColor' => $form_state['values']['daysnamescolor_theme'],
        'daysNamesFontSize' => $form_state['values']['daysnamesfontsize_theme'],
        'datesBgColors1' => $form_state['values']['datesbgcolors1_theme'],
        'datesBgColors2' => $form_state['values']['datesbgcolors2_theme'],
        'datesBgStrokeColor' => $form_state['values']['datesbgstrokecolor_theme'],
        'priority0Color' => $form_state['values']['priority0color_theme'],
        'priority1Color' => $form_state['values']['priority1color_theme'],
        'priority2Color' => $form_state['values']['priority2color_theme'],
        'priority3Color' => $form_state['values']['priority3color_theme'],
        'dateFontSize' => $form_state['values']['datefontsize_theme'],
        'dateColor' => $form_state['values']['datecolor_theme'],
        'dateStrokeColor' => $form_state['values']['datestrokecolor_theme'],
        'showDateEventsCount' => $form_state['values']['showdateeventscount_theme'],
        'dateEventsCountFontSize' => $form_state['values']['dateeventscountfontsize_theme'],
        'dateEventsCountColor' => $form_state['values']['dateeventscountcolor_theme'],
        'eventsListHeaderHeight' => $form_state['values']['eventslistheaderheight_theme'],
        'eventsListHeaderStrokeColor' => $form_state['values']['eventslistheaderstrokecolor_theme'],
        'eventsListHeaderbgColors1' => $form_state['values']['eventslistheaderbgcolors1_theme'],
        'eventsListHeaderbgColors2' => $form_state['values']['eventslistheaderbgcolors2_theme'],
        'eventsListHeaderColor' => $form_state['values']['eventslistheadercolor_theme'],
        'eventsListHeaderFontSize' => $form_state['values']['eventslistheaderfontsize_theme'],
        'eventHeaderHeight' => $form_state['values']['eventheaderheight_theme'],
        'eventHeaderFontSize' => $form_state['values']['eventheaderfontsize_theme'],
        'eventHeaderColor' => $form_state['values']['eventheadercolor_theme'],
        'eventContentBgColors1' => $form_state['values']['eventcontentbgcolors1_theme'],
        'eventContentBgColors2' => $form_state['values']['eventcontentbgcolors2_theme'],
        'eventContentDatesFontSize' => $form_state['values']['eventcontentdatesfontsize_theme'],
        'eventContentDatesColor' => $form_state['values']['eventcontentdatescolor_theme'],
        'eventContentDescriptionFontSize' => $form_state['values']['eventcontentdescriptionfontsize_theme'],
        'eventContentDescriptionColor' => $form_state['values']['eventcontentdescriptioncolor_theme'],
        'mediaDefaultAutoplay' => $form_state['values']['mediadefaultautoplay_theme'],
        'mediaScaleType' => $form_state['values']['mediascaletype_theme'],
        'mediaShowDuration' => $form_state['values']['mediashowduration_theme'],
        'videoDefaultVolume' => $form_state['values']['videodefaultvolume_theme'],
        'videoAutoplay' => $form_state['values']['videoautoplay_theme'],
        'mediaBgColor' => $form_state['values']['mediabgcolor_theme'],
        'mediaCtrlsBgColor' => $form_state['values']['mediactrlsbgcolor_theme'],
        'mediaCtrlsBgAlpha' => $form_state['values']['mediactrlsbgalpha_theme'],
        'mediaCtrlsColor' => $form_state['values']['mediactrlscolor_theme'],
        'mediaCtrlsAlpha' => $form_state['values']['mediactrlsalpha_theme'],
        'footerHeight' => $form_state['values']['footerheight_theme'],
        'footerColor' => $form_state['values']['footercolor_theme'],
        'default_settings' => 0))
      ->execute();
    drupal_set_message(t('Your theme successfully saved.'), 'status', FALSE);
    $theme_id = db_query("SELECT MAX(id) FROM {spider_fc_theme_table}")->fetchField();
  }
  $form_state['redirect'] = url('admin/settings/spider_fc/themes/new', array('query' => array('theme_id' => $theme_id), 'absolute' => TRUE));
}

/**
 * Cancel theme save.
 */
function spider_fc_theme_cancel($form, &$form_state) {
  $form_state['redirect'] = url('admin/settings/spider_fc/themes', array('absolute' => TRUE));
}
