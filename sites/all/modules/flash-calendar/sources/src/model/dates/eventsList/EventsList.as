package model.dates.eventsList {
	import model.Calendar;
	import model.Container;
	import model.Settings;
	import model.dates.eventsList.singleEvent.SingleEventContent;
	import model.dates.eventsList.singleEvent.SingleEventHeadersList;

	import flash.events.Event;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class EventsList extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const VISIBILITY_CHANGED : String = "visibilityChanged";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		private var _calendar : Calendar;
		
		private var _eventsListManager : EventsListManager;

		private var _isVisible : Boolean;
		
		private var _eventsListHeader : EventsListHeader;
		private var _singleEventHeadersList : SingleEventHeadersList;
		private var _singleEventContent : SingleEventContent;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function EventsList() : void {
			super();
			
			_settings = _controller.settings;
			_calendar = _controller.calendar;
			
			_eventsListManager = new EventsListManager();
			
			_isVisible = false;
			
			_eventsListHeader = new EventsListHeader(_eventsListManager);
			_singleEventHeadersList = new SingleEventHeadersList(_eventsListManager);
			_singleEventContent = new SingleEventContent(_eventsListManager);

			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function show() : void {
			if (_isVisible == false) {
				_isVisible = true;
				_eventsListManager.isActive = true;
				updateRect();
				dispatchEvent(new Event(VISIBILITY_CHANGED));
			}
		}

		public function hide() : void {
			if (_isVisible == true) {
				_isVisible = false;
				_eventsListManager.isActive = false;
				dispatchEvent(new Event(VISIBILITY_CHANGED));
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get isVisible() : Boolean {
			return _isVisible;
		}
		
		public function get eventsListManager() : EventsListManager {
			return _eventsListManager;
		}

		public function get eventsListHeader() : EventsListHeader {
			return _eventsListHeader;
		}
		
		public function get singleEventHeadersList() : SingleEventHeadersList {
			return _singleEventHeadersList;
		}
		
		public function get singleEventContent() : SingleEventContent {
			return _singleEventContent;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			if (_isVisible == false) {
				return;
			}
			
			var width : Number = _rect.width;			var height : Number = _rect.height;
			
			_eventsListHeader.width = width;			
			_singleEventHeadersList.width = width;
			_singleEventHeadersList.height = height - _eventsListHeader.height;
			_singleEventHeadersList.x = 0;
			_singleEventHeadersList.y = _eventsListHeader.height;
			
			var singleEventHeaderHeight : Number = _settings.eventHeaderHeight;
			_singleEventContent.width = width;
			_singleEventContent.height = height - _eventsListHeader.height - singleEventHeaderHeight;
			_singleEventContent.x = 0;
			_singleEventContent.y = _eventsListHeader.height + singleEventHeaderHeight;

			super.updateRect();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
