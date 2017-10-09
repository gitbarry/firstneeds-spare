package model.dates {
import debug.Debug;

import flash.geom.Rectangle;
	import flash.events.Event;

	import model.Calendar;
	import model.Container;
	import model.Lang;
	import model.Settings;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleDate extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_DATE_TEXT : String = "updateDateText";
		
		public static const UPDATE_SELECTED : String = "updateSelected";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const TYPE_YEAR : String = "typeYear";
		public static const TYPE_MONTH : String = "typeMonth";
		public static const TYPE_DATE : String = "typeDate";
		
		private const SPACE : Number = 2;
		public static const DATE_PERCENT : Number = 0.7;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _calendar : Calendar;
		private var _lang : Lang;
		
		private var _type : String;
		private var _date : Date;
		private var _isActive : Boolean;
		private var _isSelected : Boolean;

		private var _bgColor : int;
		
		private var _dateText : String;
		private var _dateRect : Rectangle;
		private var _dateMetricsRect : Rectangle;
		private var _dateScale : Number;
		
		private var _eventsCountText : String;
		private var _eventsCountRect : Rectangle;
		private var _eventsCountMetricsRect : Rectangle;
		private var _eventsCountScale : Number;
		
		private var _canSwitchToEvents : Boolean;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleDate(type : String, date : Date, dateTextRect : Rectangle, eventsCountRect : Rectangle) : void {
			super();
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			_lang = _controller.lang;
			
			_type = type;
			_date = new Date(date.fullYear, date.month, date.date);
			
			_isSelected = false;
			
			_dateRect = new Rectangle();
			_dateMetricsRect = dateTextRect;
			_eventsCountRect = new Rectangle();
			_eventsCountMetricsRect = eventsCountRect;
			
			parseDate();
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get type() : String {
			return _type;
		}
		
		public function get date() : Date {
			return _date;
		}
		
		public function get isActive() : Boolean {
			return _isActive;
		}
		
		public function get isSelected() : Boolean {
			return _isSelected;
		}
		
		public function set isSelected(isSelected : Boolean) : void {
			_isSelected = isSelected;
			dispatchEvent(new Event(UPDATE_SELECTED));
		}
		
		public function get dateText() : String {
			return _dateText;
		}

		public function set dateText(dateText : String) : void {
			_dateText = dateText;
			dispatchEvent(new Event(UPDATE_DATE_TEXT));
		}
		
		public function get dateRect() : Rectangle {
			return _dateRect;
		}
		
		public function set dateMetricsRect(dateMetricsRect : Rectangle) : void {
			_dateMetricsRect = dateMetricsRect;
		}
		
		public function get dateScale() : Number {
			return _dateScale;
		}
		
		public function get eventsCountText() : String {
			return _eventsCountText;
		}
		
		public function get eventsCountRect() : Rectangle {
			return _eventsCountRect;
		}
		
		public function get eventsCountScale() : Number {
			return _eventsCountScale;
		}

		public function get bgColor() : int {
			return _bgColor;
		}
		
		public function get canSwitchToEvents() : Boolean {
			return _canSwitchToEvents;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function parseDate() : void {
			var startDate : Date;
			var endDate : Date;
			var dateText : String;
			switch (_type) {
				case TYPE_YEAR:
					startDate = new Date(_date.fullYear, 0, 1);
					endDate = new Date(_date.fullYear + 1, 0, 1);
					dateText = String(_date.fullYear);
					break;
				case TYPE_MONTH:
					startDate = new Date(_date.fullYear, _date.month, 1);
					endDate = new Date(_date.fullYear, _date.month + 1, 1);
					var viewSize : String = _controller.app.viewSize;
					var months : Array = viewSize == Settings.VIEW_SIZE_MIN ? _lang.monthsShort : _lang.months;
					dateText = String(months[_date.month]);
					break;
				case TYPE_DATE:
					startDate = new Date(_date.fullYear, _date.month, _date.date);
					endDate = new Date(_date.fullYear, _date.month, _date.date + 1);
					dateText = String(_date.date);
					break;
			}
			
			var eventsList : XMLList = _calendar.getEvents(startDate, endDate);
			var eventsCount : uint = eventsList.length();
			var eventsCountText : String;
			if (eventsCount > 1) {
				eventsCountText = String(eventsCount) + " " + _lang.events;
			} else if (eventsCount == 1) {
				eventsCountText = String(eventsCount) + " " + _lang.event;
			} else {
				eventsCountText = "";
			}
			
			var priority : int;
			var highestPriority : int = -1;
			for (var i : int = 0;i < eventsCount;i++) {
				priority = MathUtils.getInRange(int(eventsList[i].priority), -1, 3);
				if (priority > highestPriority) {
					highestPriority = priority;
				}
			}
			var highestPriorityColor : int = highestPriority == -1 ? -1 : _settings["priority" + highestPriority + "Color"] as int;

			_dateText = dateText;
			_eventsCountText = eventsCountText;
			_bgColor = highestPriorityColor;
			_canSwitchToEvents = eventsCount > 0 ? true : false;
			var curYear : int = _calendar.curYear;
			var curMonth : int = _calendar.curMonth;
			if ((_type == TYPE_DATE) && ((_date.fullYear != curYear) || (_date.month != curMonth))) {
				_canSwitchToEvents = false;
			}
			
			if ((_type == TYPE_DATE) && ((_date.fullYear != curYear) || (_date.month != curMonth))) {
				_isActive = false;
			} else {
				_isActive = true;
			}
		}
		
		override protected function updateRect() : void {
			var width : Number = _rect.width;
			var height : Number = _rect.height;
			
			_dateRect.x = SPACE;
			_dateRect.y = SPACE;
			_dateRect.width = width - 2 * SPACE;
			_dateRect.height = (height - 3 * SPACE) * DATE_PERCENT;
			_dateScale = Math.min(_dateRect.width / _dateMetricsRect.width, _dateRect.height / _dateMetricsRect.height, 1);
			
			_eventsCountRect.x = SPACE;
			_eventsCountRect.y = _dateRect.y + _dateRect.height + SPACE;
			_eventsCountRect.width = width - 2 * SPACE;
			_eventsCountRect.height = height - _eventsCountRect.y - SPACE;
			_eventsCountScale = Math.min(_eventsCountRect.width / _eventsCountMetricsRect.width, _eventsCountRect.height / _eventsCountMetricsRect.height, 1);
			
			super.updateRect();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
