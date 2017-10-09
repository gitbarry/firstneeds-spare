package model {
	import debug.Debug;

	import fl.transitions.easing.Strong;

	import flash.events.EventDispatcher;

	/**
	 * @author Family
	 */
	public class Settings extends EventDispatcher {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const SETTINGS_INITED : String = "settingsInited"; //dispatched, when settings inited


		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const POS_L : String = "posL";
		public static const POS_R : String = "posR";
		public static const POS_T : String = "posT";
		public static const POS_B : String = "posB";
		public static const POS_TL : String = "posTL";
		public static const POS_TR : String = "posTR";
		public static const POS_BL : String = "posBL";
		public static const POS_BR : String = "posBR";

		public static const VIEW_STATE_YEARS : String = "viewStateYears";
		public static const VIEW_STATE_MONTHS : String = "viewStateMonths";
		public static const VIEW_STATE_DAYS : String = "viewStateDays";
		public static const VIEW_STATE_EVENTS : String = "viewStateEvents";
		public static const VIEW_STATE_EVENT : String = "viewStateEvent";

		public static const VIEW_SIZE_MIN : String = "viewSizeMin";
		public static const VIEW_SIZE_MAX : String = "viewSizeMax";

		public static const SCALE_TYPE_TOUCH_FROM_INSIDE : String = "scaleTypeTouchFromInside";
		public static const SCALE_TYPE_TOUCH_FROM_OUTSIDE : String = "scaleTypeTouchFromOutside";
		public static const SCALE_TYPE_STRATCH : String = "scaleTypeStratch";

		public static const EVENT_PRIORITY_NONE : uint = 0;
		public static const EVENT_PRIORITY_LOW : uint = 1;
		public static const EVENT_PRIORITY_MEDIUM : uint = 2;
		public static const EVENT_PRIORITY_HIGH : uint = 3;
		
		public static const STROKE_WIDTH : Number = 2;

		public static const LOADING_ANIM_TYPE_CIRCLES : String = "loadingAnimCircles";
		
		public static const REAL_TIME_TWEENER_MULTIPLIER : Number = 0.2;

		
		//////////////////
		public static const FONT : String = "Verdana";

		public static const NO_EVENTS_FOUND_MSG : String = "No Events Found";
		public static const STREAM_NOT_FOUND_MSG : String = "Stream Not Found";
		public static const ERROR_MSG_FONT_SIZE : int = 14;
		public static const ERROR_MSG_FONT_COLOR : int = 0xFFFFFF;

		public static const MIN_MAX_TWEEN_FUNC : Function = Strong.easeOut;
		public static const SWITCH_DATES_TWEEN_FUNC : Function = Strong.easeOut;

		
		//defaults
		private static const START_WITH_MONDAY : Boolean = true;
		private static const DATE_FORMAT : String = "%d-%m-%y %t";
		private static const DATE_FORMAT_SHORT : String = "%t";
		private static const TIME_12_HOURS : Boolean = false;

		private static const APP_MAX_WIDTH : Number = 800;
		private static const APP_MAX_HEIGHT : Number = 600;
		private static const APP_MIN_WIDTH : Number = 360;
		private static const APP_MIN_HEIGHT : Number = 420;

		private static const START_VIEW_STATE : String = VIEW_STATE_DAYS;
		private static const START_VIEW_SIZE : String = VIEW_SIZE_MAX;

		private static const BG_COLORS : Array = [0xffffff, 0xffffff];
		private static const BG_CORNER_RADIUS : Number = 15;
		
		private static const STROKE_COLOR : int = 0x808080;

		private static const HEADER_HEIGHT : Number = 100;
		private static const HEADER_PADDING : Number = 20;
		private static const HEADER_BG_COLORS : Array = [0xaadcff, 0x9ecff2];
		private static const HEADER_BG_STROKE_COLOR : int = 0x203540;
		private static const HEADER_CONTENT_COLOR : int = 0xffffff;
		private static const HEADER_CONTENT_STROKE_COLOR : int = 0x404040;
		private static const HEADER_FONT_SIZE : int = 40;
		
		private static const DAYS_NAMES_COLOR : int = 0x808080;
		private static const DAYS_NAMES_FONT_SIZE : int = 24;
		
		private static const DATES_BG_COLORS : Array = [0xf3f3f3, 0xe6e6e6];
		
		private static const PRIORITY_0_COLOR : int = 0x0000ff;
		private static const PRIORITY_1_COLOR : int = 0x55ff00;
		private static const PRIORITY_2_COLOR : int = 0xffd400;
		private static const PRIORITY_3_COLOR : int = 0xff0000;
		
		private static const DATE_FONT_SIZE : int = 40;
		private static const DATE_COLOR : int = 0x404040;
		private static const DATE_STROKE_COLOR : int = 0x404040;
		private static const SHOW_DATE_EVENTS_COUNT : Boolean = true;
		private static const DATE_EVENTS_COUNT_FONT_SIZE : int = 12;
		private static const DATE_EVENTS_COUNT_COLOR : int = 0x606060;
		
		private static const EVENTS_LIST_HEADER_HEIGHT : Number = 50;
		private static const EVENTS_LIST_HEADER_BG_COLORS : Array = [0xf3f3f3, 0xe6e6e6];
		private static const EVENTS_LIST_HEADER_COLOR : int = 0x404040;
		private static const EVENTS_LIST_HEADER_FONT_SIZE : int = 20;
		
		private static const EVENT_HEADER_HEIGHT : Number = 40;
		private static const EVENT_HEADER_FONT_SIZE : int = 20;
		private static const EVENT_HEADER_COLOR : int = 0x000000;
		
		private static const EVENT_CONTENT_BG_COLORS : Array = [0xf3f3f3, 0xe6e6e6];
		private static const EVENT_CONTENT_BG_ALPHA : Number = 0.5;
		
		private static const EVENT_CONTENT_DATES_FONT_SIZE : int = 18;
		private static const EVENT_CONTENT_DATES_COLOR : int = 0x808080;
		
		private static const EVENT_CONTENT_DESCRIPTION_FONT_SIZE : int = 16;
		private static const EVENT_CONTENT_DESCRIPTION_COLOR : int = 0x404040;
		
		private static const MEDIA_DEFAULT_AUTOPLAY : Boolean = true;
		private static const MEDIA_SCALE_TYPE : String = SCALE_TYPE_TOUCH_FROM_OUTSIDE;
		private static const MEDIA_SHOW_DURATION : Number = 4;
		private static const VIDEO_DEFAULT_VOLUME : Number = 0.8;
		private static const VIDEO_AUTOPLAY : Boolean = false;
		
		private static const MEDIA_BG_COLOR : int = 0x000000;
		private static const MEDIA_CTRLS_BG_COLOR : int = 0x363d40;
		private static const MEDIA_CTRLS_BG_ALPHA : Number = 0.8;
		private static const MEDIA_CTRLS_COLOR : int = 0xd3dade;
		private static const MEDIA_CTRLS_ALPHA : Number = 1;
		
		private static const FOOTER_HEIGHT : Number = 30;
		private static const FOOTER_COLOR : int = 0x808080;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public var _settingsXml : XML; //settings xml
		
		//general
		public var startWithMonday : Boolean;
		public var dateFormat : String = "%d-%m-%y %t";
		public var dateFormatShort : String = "%t";
		public var time12Hours : Boolean;

		public var appMaxWidth : Number;
		public var appMaxHeight : Number;
		public var appMinWidth : Number;
		public var appMinHeight : Number;

		public var startViewSize : String;
		public var startViewState : String;

		public var tweenDuration : Number;

		//bg
		public var bgColors : Array;
		public var bgCornerRadius : Number;
		
		public var strokeColor : int;
		
		//header
		public var headerHeight : Number;
		public var headerPadding : Number;
		public var headerBgColors : Array;
		public var headerBgStrokeColor : int;
		public var headerContentColor : int;
		public var headerContentStrokeColor : int;
		public var headerFontSize : int;
		
		//days names
		public var daysNamesColor : int;
		public var daysNamesFontSize : int;
		
		//dates
		public var datesBgColors : Array;

		public var priority0Color : int;
		public var priority1Color : int;
		public var priority2Color : int;
		public var priority3Color : int;

		//date
		public var dateFontSize : int;
		public var dateColor : int;
		public var dateStrokeColor : int;
		public var showDateEventsCount : Boolean;
		public var dateEventsCountFontSize : int;
		public var dateEventsCountColor : int;

		//events list
		public var eventsListHeaderHeight : Number;
		public var eventsListHeaderbgColors : Array;
		public var eventsListHeaderColor : int;
		public var eventsListHeaderFontSize : int;

		//event header
		public var eventHeaderHeight : Number;
		public var eventHeaderFontSize : int;
		public var eventHeaderColor : int;

		//event content
		public var eventContentBgColors : Array;

		public var eventContentDatesFontSize : int;
		public var eventContentDatesColor : int;

		public var eventContentDescriptionFontSize : int;
		public var eventContentDescriptionColor : int;

		//media
		public var loadingAnimType : String = LOADING_ANIM_TYPE_CIRCLES;
		
		public var mediaDefaultAutoplay : Boolean;
		public var mediaScaleType : String;
		public var mediaShowDuration : Number;
		public var videoDefaultVolume : Number;
		public var videoAutoplay : Boolean;

		public var mediaBgColor : int;
		public var mediaCtrlsBgColor : int;
		public var mediaCtrlsBgAlpha : Number;
		public var mediaCtrlsColor : int;
		public var mediaCtrlsAlpha : Number;
		
		//footer
		public var footerHeight : Number;
		public var footerColor : int;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////

		public function Settings(settingsXml : XML) : void {
			_settingsXml = settingsXml;
			Debug.trace('settingsXml: ' + (settingsXml));
			
			startWithMonday = getBoolean(settingsXml.startWithMonday[0], START_WITH_MONDAY);
			dateFormat = getString(settingsXml.dateFormat[0], DATE_FORMAT);
			dateFormatShort = getString(settingsXml.dateFormatShort[0], DATE_FORMAT_SHORT);
			time12Hours = getBoolean(settingsXml.time12Hours[0], TIME_12_HOURS);
			
			appMaxWidth = getNumber(settingsXml.appMaxWidth[0], APP_MAX_WIDTH);
			appMaxHeight = getNumber(settingsXml.appMaxHeight[0], APP_MAX_HEIGHT);
			appMinWidth = getNumber(settingsXml.appMinWidth[0], APP_MIN_WIDTH);
			appMinHeight = getNumber(settingsXml.appMinHeight[0], APP_MIN_HEIGHT);
			
			startViewSize = getString(settingsXml.startViewSize[0], START_VIEW_SIZE);
			if ((startViewSize != Settings.VIEW_SIZE_MIN) && (startViewSize != Settings.VIEW_SIZE_MAX)) {
				startViewSize = START_VIEW_SIZE;
			}
			startViewState = getString(settingsXml.startViewState[0], START_VIEW_STATE);
			if ((startViewState != VIEW_STATE_YEARS) && (startViewState != VIEW_STATE_MONTHS) && (startViewState != VIEW_STATE_DAYS)) {
				startViewState = START_VIEW_STATE;
			}
			
			bgColors = getArrayInt(settingsXml.bgColors[0], BG_COLORS);
			bgCornerRadius = getNumber(settingsXml.bgCornerRadius[0], BG_CORNER_RADIUS);
			
			strokeColor = getInt(settingsXml.strokeColor[0], STROKE_COLOR);
			
			headerHeight = getNumber(settingsXml.headerHeight[0], HEADER_HEIGHT);
			headerPadding = getNumber(settingsXml.headerPadding[0], HEADER_PADDING);
			headerBgColors = getArrayInt(settingsXml.headerBgColors[0], HEADER_BG_COLORS);
			headerBgStrokeColor = getInt(settingsXml.headerBgStrokeColor[0], HEADER_BG_STROKE_COLOR);
			headerContentColor = getInt(settingsXml.headerContentColor[0], HEADER_CONTENT_COLOR);
			headerContentStrokeColor = getInt(settingsXml.headerContentStrokeColor[0], HEADER_CONTENT_STROKE_COLOR);
			headerFontSize = getInt(settingsXml.headerFontSize[0], HEADER_FONT_SIZE);
			
			daysNamesColor = getInt(settingsXml.daysNamesColor[0], DAYS_NAMES_COLOR);
			daysNamesFontSize = getInt(settingsXml.daysNamesFontSize[0], DAYS_NAMES_FONT_SIZE);
			
			datesBgColors = getArrayInt(settingsXml.datesBgColors[0], DATES_BG_COLORS);
			
			priority0Color = getInt(settingsXml.priority0Color[0], PRIORITY_0_COLOR);
			priority1Color = getInt(settingsXml.priority1Color[0], PRIORITY_1_COLOR);
			priority2Color = getInt(settingsXml.priority2Color[0], PRIORITY_2_COLOR);
			priority3Color = getInt(settingsXml.priority3Color[0], PRIORITY_3_COLOR);
			
			dateFontSize = getInt(settingsXml.dateFontSize[0], DATE_FONT_SIZE);
			dateColor = getInt(settingsXml.dateColor[0], DATE_COLOR);
			dateStrokeColor = getInt(settingsXml.dateStrokeColor[0], DATE_STROKE_COLOR);
			showDateEventsCount = getBoolean(settingsXml.showDateEventsCount[0], SHOW_DATE_EVENTS_COUNT);
			dateEventsCountFontSize = getInt(settingsXml.dateEventsCountFontSize[0], DATE_EVENTS_COUNT_FONT_SIZE);
			dateEventsCountColor = getInt(settingsXml.dateEventsCountColor[0], DATE_EVENTS_COUNT_COLOR);
			
			eventsListHeaderHeight = getNumber(settingsXml.eventsListHeaderHeight[0], EVENTS_LIST_HEADER_HEIGHT);
			eventsListHeaderbgColors = getArrayInt(settingsXml.eventsListHeaderbgColors[0], EVENTS_LIST_HEADER_BG_COLORS);
			eventsListHeaderColor = getInt(settingsXml.eventsListHeaderColor[0], EVENTS_LIST_HEADER_COLOR);
			eventsListHeaderFontSize = getInt(settingsXml.eventsListHeaderFontSize[0], EVENTS_LIST_HEADER_FONT_SIZE);
			
			eventHeaderHeight = getNumber(settingsXml.eventHeaderHeight[0], EVENT_HEADER_HEIGHT);
			eventHeaderFontSize = getInt(settingsXml.eventHeaderFontSize[0], EVENT_HEADER_FONT_SIZE);
			eventHeaderColor = getInt(settingsXml.eventHeaderColor[0], EVENT_HEADER_COLOR);
		
			eventContentBgColors = getArrayInt(settingsXml.eventContentBgColors[0], EVENT_CONTENT_BG_COLORS);
		
			eventContentDatesFontSize = getInt(settingsXml.eventContentDatesFontSize[0], EVENT_CONTENT_DATES_FONT_SIZE);
			eventContentDatesColor = getInt(settingsXml.eventContentDatesColor[0], EVENT_CONTENT_DATES_COLOR);
		
			eventContentDescriptionFontSize = getInt(settingsXml.eventContentDescriptionFontSize[0], EVENT_CONTENT_DESCRIPTION_FONT_SIZE);
			eventContentDescriptionColor = getInt(settingsXml.eventContentDescriptionColor[0], EVENT_CONTENT_DESCRIPTION_COLOR);
		
			mediaDefaultAutoplay = getBoolean(settingsXml.mediaDefaultAutoplay[0], MEDIA_DEFAULT_AUTOPLAY);
			mediaScaleType = getString(settingsXml.mediaScaleType[0], MEDIA_SCALE_TYPE);
			if ((mediaScaleType != SCALE_TYPE_TOUCH_FROM_INSIDE) && (mediaScaleType != SCALE_TYPE_TOUCH_FROM_OUTSIDE) && (mediaScaleType != SCALE_TYPE_STRATCH)) {
				mediaScaleType = MEDIA_SCALE_TYPE;
			}
			mediaShowDuration = getNumber(settingsXml.mediaShowDuration[0], MEDIA_SHOW_DURATION);
			videoDefaultVolume = getNumber(settingsXml.videoDefaultVolume[0], VIDEO_DEFAULT_VOLUME);
			videoAutoplay = getBoolean(settingsXml.videoAutoplay[0], VIDEO_AUTOPLAY);

			mediaBgColor = getInt(settingsXml.mediaBgColor[0], MEDIA_BG_COLOR);
			mediaCtrlsBgColor = getInt(settingsXml.mediaCtrlsBgColor[0], MEDIA_CTRLS_BG_COLOR);
			mediaCtrlsBgAlpha = getNumber(settingsXml.mediaCtrlsBgAlpha[0], MEDIA_CTRLS_BG_ALPHA);
			mediaCtrlsColor = getInt(settingsXml.mediaCtrlsColor[0], MEDIA_CTRLS_COLOR);
			mediaCtrlsAlpha = getNumber(settingsXml.mediaCtrlsAlpha[0], MEDIA_CTRLS_ALPHA);
		
			if ((Controller.FREE_VERSION == true) && (Controller.DRUPAL == false)) {
				footerHeight = 45;
			} else {
				footerHeight = getNumber(settingsXml.footerHeight[0], FOOTER_HEIGHT);
			}
			
			footerColor = getInt(settingsXml.footerColor[0], FOOTER_COLOR);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function getBoolean(xml : XML, defaultValue : Boolean) : Boolean {
			var result : Boolean;
			if ((xml == null) || (xml == "")) {
				result = defaultValue;
			} else {
				result = xml == "true" ? true : false;
			}
			return result;
		}

		private function getNumber(xml : XML, defaultValue : Number) : Number {
			var result : Number;
			if ((xml == null) || (xml == "") || isNaN(Number(xml))) {
				result = defaultValue;
			} else {
				result = Number(xml);
			}
			
			return result;
		}

		private function getInt(xml : XML, defaultValue : int) : int {
			var result : int;
			if ((xml == null) || (xml == "") || isNaN(int(xml))) {
				result = defaultValue;
			} else {
				result = int(xml);
			}
			
			return result;
		}

		private function getString(xml : XML, defaultValue : String) : String {
			var result : String;
			if ((xml == null) || (xml == "")) {
				result = defaultValue;
			} else {
				result = String(xml);
			}
			
			return result;
		}

		private function getArrayInt(xml : XML, defaultValue : Array) : Array {
			var result : Array;
			if ((xml == null) || (xml == "")) {
				result = defaultValue;
			} else {
				result = TextUtils.removeSpaces(String(xml)).split(",");
				for (var i : int = 0;i < result.length;i++) {
					result[i] = int(result[i]);
				}
			}
			
			return result;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
