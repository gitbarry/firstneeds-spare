package model.dates.eventsList.singleEvent {
	import model.Calendar;
	import model.Container;
	import model.Settings;
	import model.dates.eventsList.EventsListManager;

	import flash.events.Event;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SingleEventHeadersList extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_EVENTS : String = "updateEvents";
		public static const IS_EVENT_OPENED_CHANGED : String = "isEventOpenedChanged";
		public static const OPENED_EVENT_CHANGED : String = "openedEventChanged";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _calendar : Calendar;

		private var _eventsListManager : EventsListManager;

		private var _singleEventHeaders : Array;
		private var _singleEventHeaderHeight : Number;

		private var _isEventOpened : Boolean;
		private var _openedEventIndex : int;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SingleEventHeadersList(eventsListManager : EventsListManager) : void {
			super();
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			
			_eventsListManager = eventsListManager;
			
			_singleEventHeaders = new Array();
			_singleEventHeaderHeight = _settings.eventHeaderHeight;
			
			_eventsListManager.addEventListener(EventsListManager.UPDATE_EVENTS, updateEventsHandler);
			_eventsListManager.addEventListener(EventsListManager.IS_EVENT_OPENED_CHANGED, isEventOpenedChangedHandler);
			_eventsListManager.addEventListener(EventsListManager.OPENED_EVENT_INDEX_CHANGED, openedEventIndexChangedHandler);
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get singleEventHeaders() : Array {
			return _singleEventHeaders;
		}

		public function get isEventOpened() : Boolean {
			return _isEventOpened;
		}

		public function get openedEventIndex() : int {
			return _openedEventIndex;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			for (var i : uint;i < _singleEventHeaders.length;i++) {
				var singleEventHeader : SingleEventHeader = _singleEventHeaders[i] as SingleEventHeader;
				singleEventHeader.width = _rect.width;
			}
			
			super.updateRect();
		}

		private function updateEvents() : void {
			_singleEventHeaders = new Array();
			
			var singleEvents : Array = _eventsListManager.singleEvents;
			var i : uint;
			var singleEvent : SingleEvent;
			var singleEventHeader : SingleEventHeader;
			for (i = 0;i < singleEvents.length;i++) {
				singleEvent = singleEvents[i] as SingleEvent;
				singleEventHeader = new SingleEventHeader(singleEvent.index, singleEvent.title, singleEvent.type, singleEvent.priority);
				singleEventHeader.y = i * _singleEventHeaderHeight;
				singleEventHeader.width = _rect.width;
				singleEventHeader.height = _singleEventHeaderHeight;
				_singleEventHeaders[i] = singleEventHeader;
			}
			
			dispatchEvent(new Event(UPDATE_EVENTS));
		}

		private function updateIsEventOpened() : void {
			_isEventOpened = _eventsListManager.isEventOpened;
			
			if (_isEventOpened == false) {
				var singleEventHeader : SingleEventHeader = _singleEventHeaders[_openedEventIndex];
				if (singleEventHeader != null) {
					singleEventHeader.isOpened = false;
				}
			}
			
			dispatchEvent(new Event(IS_EVENT_OPENED_CHANGED));
		}

		private function updateOpenedEventIndex() : void {
			var singleEventHeader : SingleEventHeader = _singleEventHeaders[_openedEventIndex];
			if (singleEventHeader != null) {
				singleEventHeader.isOpened = false;
			}
			
			if (_isEventOpened == false) {
				return;
			}
			
			_openedEventIndex = _eventsListManager.openedEventIndex;


            singleEventHeader = _singleEventHeaders[_openedEventIndex];
            singleEventHeader.isOpened = true;

            dispatchEvent(new Event(OPENED_EVENT_CHANGED));
        }

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateEventsHandler(event : Event) : void {
			updateEvents();
		}

		private function isEventOpenedChangedHandler(event : Event) : void {
			updateIsEventOpened();
		}

		private function openedEventIndexChangedHandler(event : Event) : void {
			updateOpenedEventIndex();
		}
	}
}
