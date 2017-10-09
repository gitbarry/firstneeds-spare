package model.dates {
	import model.App;
	import model.Calendar;
	import model.Container;
	import model.Lang;
	import model.Settings;

	import uiElements.text.TFUtils;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class DatesList extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const VISIBILITY_CHANGED : String = "visibilityChanged";
		public static const UPDATE_STATE : String = "updateState";		public static const UPDATE_DATES : String = "updateDates";

		public static const GET_SNAP : String = "getSnap";
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const STATE_YEARS : String = "stateYears";		public static const STATE_MONTHS : String = "stateMonths";		public static const STATE_DAYS : String = "stateDays";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;		private var _calendar : Calendar;		private var _lang : Lang;

		private var _isVisible : Boolean;

		private var _state : String;
		private var _curDate : Date;

		private var _cols : uint;
		private var _rows : uint;

		private var _dates : Array;		private var _selectedDate : SingleDate;

		private var _yearTextRect : Rectangle;		private var _monthMinTextRect : Rectangle;		private var _monthMaxTextRect : Rectangle;		private var _dateTextRect : Rectangle;		private var _eventsCountTextRect : Rectangle;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function DatesList() : void {
			super();
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			_lang = _controller.lang;
			
			_isVisible = true;
			
			determineTextMetrics();
			
			switch (_settings.startViewState) {
				case Settings.VIEW_STATE_YEARS:
					setState(STATE_YEARS);
					break;
				case Settings.VIEW_STATE_MONTHS:
					setState(STATE_MONTHS);
					break;
				case Settings.VIEW_STATE_DAYS:
					setState(STATE_DAYS);
					break;
			}
			
			_calendar.addEventListener(Calendar.DATE_CHANGED, dateChangedHandler);
			_controller.app.addEventListener(App.VIEW_SIZE_CHANGED, viewSizeChangedHandler);
			
			updateDate();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function show() : void {
			_isVisible = true;
			
			updateDates();
			
			dispatchEvent(new Event(VISIBILITY_CHANGED));
		}

		public function hide() : void {
			_isVisible = false;
			
			dispatchEvent(new Event(VISIBILITY_CHANGED));
		}

		public function setState(state : String) : void {
			if (_state == state) {
				return;
			}
			
			_state = state;
			dispatchEvent(new Event(UPDATE_STATE));
			
			updateDates();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get isVisible() : Boolean {
			return _isVisible;
		}

		public function get state() : String {
			return _state;
		}

		public function get cols() : uint {
			return _cols;
		}

		public function get rows() : uint {
			return _rows;
		}

		public function get dates() : Array {
			return _dates;
		}

		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function determineTextMetrics() : void {
			var font : String = Settings.FONT;
			var dateFontSize : int = _controller.settings.dateFontSize;
			
			_yearTextRect = TFUtils.getTFMetrics("0000", font, dateFontSize);
			
			_monthMinTextRect = new Rectangle();			_monthMaxTextRect = new Rectangle();
			var monthsShort : Array = _lang.monthsShort;			var months : Array = _lang.months;
			var i : uint;
			var monthRect : Rectangle;
			for (i = 0;i < 12;i++) {
				monthRect = TFUtils.getTFMetrics(monthsShort[i], font, dateFontSize);
				if (_monthMinTextRect.width < monthRect.width) {
					_monthMinTextRect.width = monthRect.width;				}
				if (_monthMinTextRect.height < monthRect.height) {
					_monthMinTextRect.height = monthRect.height;
				}
				
				monthRect = TFUtils.getTFMetrics(months[i], font, dateFontSize);
				if (_monthMaxTextRect.width < monthRect.width) {
					_monthMaxTextRect.width = monthRect.width;
				}
				if (_monthMaxTextRect.height < monthRect.height) {
					_monthMaxTextRect.height = monthRect.height;
				}
			}
						_dateTextRect = TFUtils.getTFMetrics("0000", font, dateFontSize);
			
			var eventsCountFontSize : int = _settings.dateEventsCountFontSize;			_eventsCountTextRect = TFUtils.getTFMetrics("00 " + _lang.events, font, eventsCountFontSize);
		}

		
		override protected function updateRect() : void {
			if (_isVisible == false) {
				return;
			}
			
			var width : Number = _rect.width;			var height : Number = _rect.height;
			
			var i : uint;			var j : uint;
			var singleDate : SingleDate;
			var singleDateWidth : Number = width / _cols - 1;
			var singleDateHeight : Number = height / _rows - 1;
			for (i = 0;i < _rows;i++) {
				for (j = 0;j < _cols;j++) {
					singleDate = _dates[i][j] as SingleDate;
					singleDate.x = 0.5 + j + j * singleDateWidth;
					singleDate.y = 0.5 + i + i * singleDateHeight;
					singleDate.width = singleDateWidth;
					singleDate.height = singleDateHeight;
				}
			}
			
			super.updateRect();
		}

		private function updateDate() : void {
			if (_selectedDate != null) {
				_selectedDate.isSelected = false;
				_selectedDate = null;
			}
			
			var year : int = _calendar.curYear;			var month : int = _calendar.curMonth;			var date : int = _calendar.curDate;
			
			var isSameYears : Boolean;
			var isSameMonths : Boolean;			var isSameDays : Boolean;
			
			if (_curDate == null) {
				_curDate = new Date();
				isSameYears = false;				isSameMonths = false;				isSameDays = false;
			} else {
				isSameYears = Math.floor(_curDate.fullYear / 12) == Math.floor(year / 12) ? true : false;
				isSameMonths = _curDate.fullYear == year ? true : false;
				isSameDays = _curDate.month == month ? true : false;
			}
			
			_curDate.fullYear = year;
			_curDate.month = month;
			_curDate.date = date;
			
			var i : uint;
			var j : uint;
			var singleDate : SingleDate;
			switch (_state) {
				case STATE_YEARS:
					if (isSameYears == false) {
						updateDates();
					}
					for (i = 0;i < _dates.length;i++) {
						for (j = 0;j < _dates[0].length; j++) {
							singleDate = _dates[i][j] as SingleDate;
							if (singleDate.date.fullYear == year) {
								singleDate.isSelected = true;
								_selectedDate = singleDate;
							}
						}
					}
					break;
				case STATE_MONTHS:
					if ((isSameMonths == false)) {
						updateDates();
					}
					for (i = 0;i < _dates.length;i++) {
						for (j = 0;j < _dates[0].length; j++) {
							singleDate = _dates[i][j] as SingleDate;
							if ((singleDate.date.fullYear == year) && (singleDate.date.month == month)) {
								singleDate.isSelected = true;
								_selectedDate = singleDate;
							}
						}
					}
					break;
				case STATE_DAYS:
					if ((isSameMonths == false) || (isSameDays == false)) {
						updateDates();
					}
					for (i = 0;i < _dates.length;i++) {
						for (j = 0;j < _dates[0].length; j++) {
							singleDate = _dates[i][j] as SingleDate;
							if ((singleDate.date.fullYear == year) && (singleDate.date.month == month) && (singleDate.date.date == date)) {
								singleDate.isSelected = true;
								_selectedDate = singleDate;
							}
						}
					}
					break;
			}
		}

		private function updateDates() : void {
			if (_isVisible == false) {
				return;
			}
			
			dispatchEvent(new Event(GET_SNAP));
			
			var i : uint;
			var j : uint;
			var row : Array;
			var singleDate : SingleDate;
			
			var curYear : int = _calendar.curYear;			var curMonth : int = _calendar.curMonth;			var curDate : int = _calendar.curDate;
			
			var date : Date;			
			_dates = new Array();
			switch (_state) {
				case STATE_YEARS:
					_cols = 4;
					_rows = 3;
					date = new Date(curYear - curYear % 12, 0, 1);
					for (i = 0;i < _rows;i++) {
						row = new Array();
						for (j = 0;j < _cols;j++) {
							singleDate = new SingleDate(SingleDate.TYPE_YEAR, date, _yearTextRect, _eventsCountTextRect);
							if (date.fullYear == curYear) {
								singleDate.isSelected = true;
								_selectedDate = singleDate;
							}
							row[j] = singleDate;
							
							//							if (_calendar.curYear == date.fullYear) {
							//								_singleDates[row][col].state = SingleDate.STATE_SELECTED;
							//							} else {
							//								_singleDates[row][col].state = SingleDate.STATE_UNSELECTED;
							//							}

							date.fullYear++;
						}
						_dates[i] = row;
					}
					break;
				case STATE_MONTHS:
					_cols = 4;
					_rows = 3;
					var viewSize : String = _controller.app.viewSize;
					var monthTextRect : Rectangle = viewSize == Settings.VIEW_SIZE_MIN ? _monthMinTextRect : _monthMaxTextRect;
					date = new Date(curYear, 0, 1);
					for (i = 0;i < _rows;i++) {
						row = new Array();
						for (j = 0;j < _cols;j++) {
							singleDate = new SingleDate(SingleDate.TYPE_MONTH, date, monthTextRect, _eventsCountTextRect);
							if ((date.fullYear == curYear) && (date.month == curMonth)) {
								singleDate.isSelected = true;
								_selectedDate = singleDate;
							}
							row[j] = singleDate;
							
							//							if (_calendar.curYear == date.fullYear) {
							//								_singleDates[row][col].state = SingleDate.STATE_SELECTED;
							//							} else {
							//								_singleDates[row][col].state = SingleDate.STATE_UNSELECTED;
							//							}

							date.month++;
						}
						_dates[i] = row;
					}
					break;
				case STATE_DAYS:
					_cols = 7;
					_rows = 6;
					date = new Date(curYear, curMonth, 1);
					var startWithMonday : Boolean = _settings.startWithMonday == true ? true : false; 
					date.date = date.date - date.day;
					if (startWithMonday == true) {
						if (date.date == 1) {
							date.date -= 6;
						} else {
							date.date++;
						}
					}
			
					for (i = 0;i < _rows;i++) {
						row = new Array();
						for (j = 0;j < _cols;j++) {
							singleDate = new SingleDate(SingleDate.TYPE_DATE, date, _dateTextRect, _eventsCountTextRect);
							if ((date.fullYear == curYear) && (date.month == curMonth) && (date.date == curDate)) {
								singleDate.isSelected = true;
								_selectedDate = singleDate;
							}
							row[j] = singleDate;
							
							//							if ((_calendar.curDate == day.date) && (_calendar.curMonth == day.month) && (_calendar.curYear == day.fullYear)) {
							//								singleDate.state = SingleDate.STATE_SELECTED;
							//							} else {
							//								singleDate.state = SingleDate.STATE_UNSELECTED;
							//							}

							date.date++;
						}
						_dates[i] = row;
					}
					break;
			}
			
			dispatchEvent(new Event(UPDATE_DATES));
			
			updateRect();
		}

		private function updateViewSize() : void {
			if (_state != STATE_MONTHS) {
				return;
			}
			
			var i : uint;
			var j : uint;
			var singleDate : SingleDate;
			var viewSize : String = _controller.app.viewSize;
			var months : Array = viewSize == Settings.VIEW_SIZE_MIN ? _lang.monthsShort : _lang.months;
			var monthTextRect : Rectangle = viewSize == Settings.VIEW_SIZE_MIN ? _monthMinTextRect : _monthMaxTextRect;
			for (i = 0;i < _rows;i++) {
				for (j = 0;j < _cols;j++) {
					singleDate = _dates[i][j] as SingleDate;
					singleDate.dateText = months[i * 4 + j] as String;					singleDate.dateMetricsRect = monthTextRect;
				}
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function dateChangedHandler(event : Event) : void {
			updateDate();
		}

		private function viewSizeChangedHandler(event : Event) : void {
			updateViewSize();
		}
	}
}
