/**
 * Select theme.
 */
function spider_fc_set_theme() {
  themeID = document.getElementById('edit-default-themes').value;
  var if_set;
  switch (themeID) {
    case '1':
      if_set = spider_fc_reset_theme_1();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Simple blue";
      }
      break;

    case '2':
      if_set = spider_fc_reset_theme_2();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Baby blue";
      }
      break;

    case '3':
      if_set = spider_fc_reset_theme_3();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Midnight blue";
      }
      break;

    case '4':
      if_set = spider_fc_reset_theme_4();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Sky blue";
      }
      break;

    case '5':
      if_set = spider_fc_reset_theme_5();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Indian Red";
      }
      break;

    case '6':
      if_set = spider_fc_reset_theme_6();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Dodger blue";
      }
      break;

    case '7':
      if_set = spider_fc_reset_theme_7();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Red blur";
      }
      break;

    case '8':
      if_set = spider_fc_reset_theme_8();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Light brown";
      }
      break;

    case '9':
      if_set = spider_fc_reset_theme_9();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Simple grey";
      }
      break;

    case '10':
      if_set = spider_fc_reset_theme_10();
      if (if_set) {
        document.getElementById("edit-theme-title").value = "new_Black";
      }
      break;
  }
}

/**
 * Reset default theme.
 */
function spider_fc_reset_theme_1() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "800";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("FFFFFF");
    document.getElementById("edit-bgcolors2-theme").color.fromString("FFFFFF");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-bgcornerradius-theme").value = "15";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("808080");
    document.getElementById("edit-daysnamesfontsize-theme").value = "24";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("404040");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("808080");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "20";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("AADCFF");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("9ECFF2");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = true;
    document.getElementById("edit-videoautoplay-theme-0").checked = false;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_2() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "600";
    document.getElementById("edit-appmaxheight-theme").value = "550";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("84CFEE");
    document.getElementById("edit-bgcolors2-theme").color.fromString("499BD5");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-bgcornerradius-theme").value = "15";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("FFFFFF");
    document.getElementById("edit-daysnamesfontsize-theme").value = "24";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("9EC8E0");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("9EC8E0");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("FFFFFF");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("D1D1D1");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "0";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("4CA0DE");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("7FCDF3");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("4CA0DE");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_3() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "600";
    document.getElementById("edit-appmaxheight-theme").value = "550";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("FFFFFF");
    document.getElementById("edit-bgcolors2-theme").color.fromString("FFFFFF");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-bgcornerradius-theme").value = "15";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("025287");
    document.getElementById("edit-daysnamesfontsize-theme").value = "20";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("CFEBFF");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("AFDDFF");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "33";
    document.getElementById("edit-datecolor-theme").color.fromString("404040");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("025F9C");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "2";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("025F9C");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("025F9C");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_4() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "650";
    document.getElementById("edit-appmaxheight-theme").value = "550";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("FFFFFF");
    document.getElementById("edit-bgcolors2-theme").color.fromString("FFFFFF");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-bgcornerradius-theme").value = "8";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("17506B");
    document.getElementById("edit-daysnamesfontsize-theme").value = "20";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("FFFFFF");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("FFFFFF");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "33";
    document.getElementById("edit-datecolor-theme").color.fromString("404040");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("025F9C");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "0";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("37BEFE");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("37BEFE");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_5() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "700";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("FFEFA3");
    document.getElementById("edit-bgcolors2-theme").color.fromString("5D2117");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-bgcornerradius-theme").value = "6";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("000000");
    document.getElementById("edit-daysnamesfontsize-theme").value = "20";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("7E3F30");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("7E3F30");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("FFFFFF");
    document.getElementById("edit-priority1color-theme").color.fromString("FFE8B9");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("FBEDBE");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("808080");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "2";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("7E3F30");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("9C4E3B");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_6() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "700";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("EDEDED");
    document.getElementById("edit-bgcolors2-theme").color.fromString("4196E9");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("000000");
    document.getElementById("edit-bgcornerradius-theme").value = "6";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("000000");
    document.getElementById("edit-daysnamesfontsize-theme").value = "24";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("E2EDF7");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("C6D0D9");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("3E90E0");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("050505");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("050505");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("FFFFFF");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("D6D6D6");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "2";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("4196E9");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("6782AD");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_7() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "700";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("FFFFCD");
    document.getElementById("edit-bgcolors2-theme").color.fromString("C7C7A0");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("000000");
    document.getElementById("edit-bgcornerradius-theme").value = "6";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("000000");
    document.getElementById("edit-daysnamesfontsize-theme").value = "22";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("CECB96");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("DEDBA2");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "33";
    document.getElementById("edit-datecolor-theme").color.fromString("000000");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("9A0000");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("3D3D3D");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "12";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("9A0000");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("B50000");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "36";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_8() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "700";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("523F30");
    document.getElementById("edit-bgcolors2-theme").color.fromString("8F6E54");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-bgcornerradius-theme").value = "15";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("FFFFFF");
    document.getElementById("edit-daysnamesfontsize-theme").value = "20";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("7E5F43");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("BD8E64");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("EBEBEB");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("E7C892");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("808080");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "20";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("BE7530");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("E7C892");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_9() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "700";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("2D2D2D");
    document.getElementById("edit-bgcolors2-theme").color.fromString("222222");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("000000");
    document.getElementById("edit-bgcornerradius-theme").value = "0";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("FFFFFF");
    document.getElementById("edit-daysnamesfontsize-theme").value = "20";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("E1E1E1");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("F5F5F5");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("4D9AFF");
    document.getElementById("edit-priority1color-theme").color.fromString("55FF00");
    document.getElementById("edit-priority2color-theme").color.fromString("FFD400");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("404040");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("606060");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("000000");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("808080");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "2";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("2D2D2D");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("222222");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("203540");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

function spider_fc_reset_theme_10() {
  if (confirm(Drupal.t('Do you really whant to reset theme?'))) {
    // General parametres.
    document.getElementById("edit-week-start-day-1").checked = true;
    document.getElementById("edit-week-start-day-0").checked = false;
    document.getElementById("edit-date-format").value = "%m-%d-%y %t";
    document.getElementById("edit-date-format-format").value = "%t";
    document.getElementById("edit-time-theme-1").checked = false;
    document.getElementById("edit-time-theme-0").checked = true;
    document.getElementById("edit-appmaxwidth-theme").value = "700";
    document.getElementById("edit-appmaxheight-theme").value = "600";
    document.getElementById("edit-appminwidth-theme").value = "360";
    document.getElementById("edit-appminheight-theme").value = "420";
    document.getElementById("edit-startviewsize-theme").value = "viewSizeMax";
    document.getElementById("edit-startviewstate-theme").value = "viewStateDays";
    document.getElementById("edit-bgcolors1-theme").color.fromString("0A0A0A");
    document.getElementById("edit-bgcolors2-theme").color.fromString("101010");
    document.getElementById("edit-bgstrokecolor-theme").color.fromString("08BDF4");
    document.getElementById("edit-bgcornerradius-theme").value = "12";
    
    // Body parametres.
    document.getElementById("edit-daysnamescolor-theme").color.fromString("C7C7C7");
    document.getElementById("edit-daysnamesfontsize-theme").value = "20";
    document.getElementById("edit-datesbgcolors1-theme").color.fromString("050507");
    document.getElementById("edit-datesbgcolors2-theme").color.fromString("050507");
    document.getElementById("edit-datesbgstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-priority0color-theme").color.fromString("A9FF9C");
    document.getElementById("edit-priority1color-theme").color.fromString("61FF7B");
    document.getElementById("edit-priority2color-theme").color.fromString("0A0A0A");
    document.getElementById("edit-priority3color-theme").color.fromString("FF0000");
    document.getElementById("edit-datefontsize-theme").value = "40";
    document.getElementById("edit-datecolor-theme").color.fromString("A6A6A6");
    document.getElementById("edit-datestrokecolor-theme").color.fromString("D90000");
    document.getElementById("edit-showdateeventscount-theme-1").checked = true;
    document.getElementById("edit-showdateeventscount-theme-0").checked = false;
    document.getElementById("edit-dateeventscountfontsize-theme").value = "12";
    document.getElementById("edit-dateeventscountcolor-theme").color.fromString("08BDF4");
    document.getElementById("edit-eventslistheaderheight-theme").value = "50";
    document.getElementById("edit-eventslistheaderstrokecolor-theme").color.fromString("808080");
    document.getElementById("edit-eventslistheaderbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventslistheaderbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventslistheadercolor-theme").color.fromString("404040");
    document.getElementById("edit-eventslistheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheaderheight-theme").value = "40";
    document.getElementById("edit-eventheaderfontsize-theme").value = "20";
    document.getElementById("edit-eventheadercolor-theme").color.fromString("FFFFFF");
    document.getElementById("edit-eventcontentbgcolors1-theme").color.fromString("F3F3F3");
    document.getElementById("edit-eventcontentbgcolors2-theme").color.fromString("E6E6E6");
    document.getElementById("edit-eventcontentdatesfontsize-theme").value = "18";
    document.getElementById("edit-eventcontentdatescolor-theme").color.fromString("808080");
    document.getElementById("edit-eventcontentdescriptionfontsize-theme").value = "16";
    document.getElementById("edit-eventcontentdescriptioncolor-theme").color.fromString("404040");
    document.getElementById("edit-footerheight-theme").value = "30";
    document.getElementById("edit-footercolor-theme").color.fromString("FCFCFC");
    
    // Header parametres.
    document.getElementById("edit-headerheight-theme").value = "100";
    document.getElementById("edit-headerpadding-theme").value = "14";
    document.getElementById("edit-headerbgcolors1-theme").color.fromString("0A0A0A");
    document.getElementById("edit-headerbgcolors2-theme").color.fromString("101010");
    document.getElementById("edit-headerbgstrokecolor-theme").color.fromString("08BDF4");
    document.getElementById("edit-headercontentcolor-theme").value = "FFFFFF";
    document.getElementById("edit-headercontentstrokecolor-theme").color.fromString("404040");
    document.getElementById("edit-headerfontsize-theme").value = "40";
    
    // Media parametres.
    document.getElementById("edit-mediadefaultautoplay-theme-1").checked = true;
    document.getElementById("edit-mediadefaultautoplay-theme-0").checked = false;
    document.getElementById("edit-mediascaletype-theme").value = "scaleTypeTouchFromOutside";
    document.getElementById("edit-mediashowduration-theme").value = "5";
    document.getElementById("SpiderFC_videoDefaultVolume").value = "80";
    document.getElementById("edit-videoautoplay-theme-1").checked = false;
    document.getElementById("edit-videoautoplay-theme-0").checked = true;
    document.getElementById("edit-mediabgcolor-theme").color.fromString("000000");
    document.getElementById("edit-mediactrlsbgcolor-theme").color.fromString("363D40");
    document.getElementById("SpiderFC_mediaCtrlsBgAlpha").value = "80";
    document.getElementById("edit-mediactrlscolor-theme").color.fromString("D3DADE");
    document.getElementById("SpiderFC_mediaCtrlsAlpha").value = "100";
    spider_fc_reset_theme_slider("SpiderFC_videoDefaultVolume", "slider-videoDefaultVolume3", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsBgAlpha", "slider-videoDefaultVolume2", "80");
    spider_fc_reset_theme_slider("SpiderFC_mediaCtrlsAlpha", "slider-videoDefaultVolume1", "100");
    return true;
  }
  else {
    return false;
  }
}

/**
 * Change slider on reset default theme.
 */
function spider_fc_reset_theme_slider(idtaginp, idtagdiv, inpvalue) {
  jQuery("#" + idtagdiv).slider({
    range:"min",
    value:inpvalue,
    min:0,
    max:100,
    slide:function (event, ui) {
      jQuery("#" + idtaginp).val("" + ui.value);
    }
  });
  jQuery("#" + idtaginp).val("" + jQuery("#" + idtagdiv).slider("value"));
}

/**
 * Change slider deppend on input percent.
 */
function spider_fc_change_theme_slider(idtaginp, idtagdiv) {
  var inpvalue = jQuery("#" + idtaginp).val();
  if (inpvalue == "") {
    inpvalue = 28;
  }
  jQuery("#" + idtagdiv).slider({
    range:"min",
    value:inpvalue,
    min:0,
    max:100,
    slide:function (event, ui) {
      jQuery("#" + idtaginp).val("" + ui.value);
    }
  });
  jQuery("#" + idtaginp).val("" + jQuery("#" + idtagdiv).slider("value"));
}
