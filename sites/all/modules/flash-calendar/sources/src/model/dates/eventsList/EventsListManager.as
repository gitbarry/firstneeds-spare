package model.dates.eventsList {
	import debug.Debug;

	import model.App;
	import model.Calendar;
	import model.Settings;
	import model.dates.eventsList.singleEvent.SingleEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class EventsListManager extends EventDispatcher {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_EVENTS : String = "updateEvents";
		public static const IS_EVENT_OPENED_CHANGED : String = "isEventOpenedChanged";
		public static const OPENED_EVENT_INDEX_CHANGED : String = "openedEventIndexChanged";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const PERIOD_YEAR : String = "periodYear";
		public static const PERIOD_MONTH : String = "periodMonth";
		public static const PERIOD_DAY : String = "periodDay";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;
		
		private var _calendar : Calendar;
		
		private var _isActive : Boolean;

		private var _date : Date;
		private var _period : String;
		
		private var _singleEvents : Array;

		private var _isEventOpened : Boolean;
		private var _openedEventIndex : int;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function EventsListManager() : void {
			_controller = Controller.getInstance();
			_calendar = _controller.calendar;
			
			_isActive = false;
			
			_date = new Date(0);
			
			_singleEvents = new Array();
			
			_isEventOpened = false;
			
			_controller.app.addEventListener(App.VIEW_STATE_CHANGED, viewStateChangedHandler);
			_calendar.addEventListener(Calendar.DATE_CHANGED, dateChangedHandler);
			
			updateDate();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get isActive() : Boolean {
			return _isActive;
		}
		
		public function set isActive(isActive : Boolean) : void {
			_isActive = isActive;
			updateEvents();
		}
		
		public function get period() : String {
			return _period;
		}
		
		public function get singleEvents() : Array {
			return _singleEvents;
		}
		
		public function get isEventOpened() : Boolean {
			return _isEventOpened;
		}
		
		public function set isEventOpened(isEventOpened : Boolean) : void {
			_isEventOpened = isEventOpened;
			dispatchEvent(new Event(IS_EVENT_OPENED_CHANGED));
		}
		
		public function get openedEventIndex() : int {
			return _openedEventIndex;
		}
		
		public function set openedEventIndex(openedEventIndex : int) : void {
			if ((openedEventIndex < 0) || (openedEventIndex > _singleEvents.length - 1)) {
				return;
			}
			_openedEventIndex = openedEventIndex;
			dispatchEvent(new Event(OPENED_EVENT_INDEX_CHANGED));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updatePeriod() : void {
			var viewState : String = _controller.app.viewState;
			switch (viewState) {
				case Settings.VIEW_STATE_YEARS:
					_period = PERIOD_YEAR;
					break;
				case Settings.VIEW_STATE_MONTHS:
					_period = PERIOD_MONTH;
					break;
				case Settings.VIEW_STATE_DAYS:
					_period = PERIOD_DAY;
					break;
			}
			
			if (viewState != Settings.VIEW_STATE_EVENT) {
				isEventOpened = false;
			}
		}
		
		private function updateDate() : void {
			var curYear : int = _calendar.curYear;			var curMonth : int = _calendar.curMonth;			var curDate : int = _calendar.curDate;
			
			var update : Boolean = false;
			switch (_period) {
				case PERIOD_YEAR:
					if (_date.fullYear != curYear) {
						update = true;
					}
					break;
				case PERIOD_MONTH:
					if ((_date.fullYear != curYear) || (_date.month != curMonth)) {
						update = true;
					}
					break;
				case PERIOD_DAY:
					if ((_date.fullYear != curYear) || (_date.month != curMonth) || (_date.date != curDate)) {
						update = true;
					}
					break;
			}
			
			_date.fullYear = curYear;			_date.month = curMonth;			_date.date = curDate;
			
			if (update == true) {
				isEventOpened = false;
				updateEvents();
			}
		}

		private function updateEvents() : void {
			if (_isActive == false) {
				return;
			}
			
			var startDate : Date;
			var endDate : Date;
			switch (_period) {
				case PERIOD_YEAR:
					startDate = new Date(_calendar.curYear, 0, 1);
					endDate = new Date(startDate.fullYear + 1, 0, 1);
					break;
				case PERIOD_MONTH:
					startDate = new Date(_calendar.curYear, _calendar.curMonth, 1);
					endDate = new Date(startDate.fullYear, startDate.month + 1, 1);
					break;
				case PERIOD_DAY:
					startDate = new Date(_calendar.curYear, _calendar.curMonth, _calendar.curDate);
					endDate = new Date(startDate.fullYear, startDate.month, startDate.date + 1);
					break;
			}
			
			var eventsXmlList : XMLList = _calendar.getEvents(startDate, endDate);
			
			_singleEvents = new Array();
			var singleEvent : SingleEvent;
			for (var i : uint = 0;i < eventsXmlList.length();i++) {
				singleEvent = new SingleEvent(i, eventsXmlList[i]);
				_singleEvents[i] = singleEvent;
			}
			
			dispatchEvent(new Event(UPDATE_EVENTS));
			
			openedEventIndex = 0;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function viewStateChangedHandler(event : Event) : void {
			updatePeriod();
		}
		
		private function dateChangedHandler(event : Event) : void {
			updateDate();
		}
	}
}
