package model.dates {
	import model.App;
	import model.Calendar;
	import model.Container;
	import model.Lang;
	import model.Settings;
	import model.dates.eventsList.EventsList;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Dates extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const GET_SNAP : String = "getSnap";		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;		private var _lang : Lang;		private var _calendar : Calendar;

		private var _bgRect : Rectangle;

		private var _daysNames : DaysNames;
		private var _datesList : DatesList;
		private var _eventsList : EventsList;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Dates() : void {
			super();
			
			_settings = _controller.settings;
			_lang = _controller.lang;
			_calendar = _controller.calendar;
			
			_bgRect = new Rectangle();
			
			_daysNames = new DaysNames();
			_datesList = new DatesList();			_eventsList = new EventsList();
			
			_controller.app.addEventListener(App.VIEW_STATE_CHANGED, viewStateChangedHandler);
			
			_datesList.addEventListener(DatesList.GET_SNAP, getSnapHandler);			
			updateRect();
			updateViewState();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function hideEventsList() : void {
			switch (_datesList.state) {
				case DatesList.STATE_YEARS:
					_controller.app.viewState = Settings.VIEW_STATE_YEARS;
					break;
				case DatesList.STATE_MONTHS:
					_controller.app.viewState = Settings.VIEW_STATE_MONTHS;
					break;
				case DatesList.STATE_DAYS:
					_controller.app.viewState = Settings.VIEW_STATE_DAYS;
					break;
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get daysNames() : DaysNames {
			return _daysNames;
		}

		public function get datesList() : DatesList {
			return _datesList;
		}

		public function get eventsList() : EventsList {
			return _eventsList;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			_bgRect.width = _rect.width;
			_bgRect.height = _rect.height;
			
			var viewState : String = _controller.app.viewState;
			var daysNamesHeight : Number = viewState == Settings.VIEW_STATE_DAYS ? _daysNames.height : 0;
			
			_datesList.y = daysNamesHeight;
			_datesList.width = _rect.width;			_datesList.height = _rect.height - daysNamesHeight;
			
			_eventsList.width = _rect.width;			_eventsList.height = _rect.height;
			
			super.updateRect();		}

		public function updateViewState() : void {
			dispatchEvent(new Event(GET_SNAP));
			
			var viewState : String = _controller.app.viewState;
			switch (viewState) {
				case Settings.VIEW_STATE_YEARS:
					_eventsList.hide();
					_datesList.show();
					_datesList.setState(DatesList.STATE_YEARS);
					break;
				case Settings.VIEW_STATE_MONTHS:
					_eventsList.hide();
					_datesList.show();
					_datesList.setState(DatesList.STATE_MONTHS);
					break;
				case Settings.VIEW_STATE_DAYS:
					_eventsList.hide();
					_datesList.show();
					_datesList.setState(DatesList.STATE_DAYS);
					break;
				case Settings.VIEW_STATE_EVENTS:				case Settings.VIEW_STATE_EVENT:
					_datesList.hide();
					_eventsList.show();
					break;
			}
			
			_daysNames.isVisible = viewState == Settings.VIEW_STATE_DAYS ? true : false;
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function viewStateChangedHandler(event : Event) : void {
			updateViewState();
		}
		
		private function getSnapHandler(event : Event) : void {
			dispatchEvent(new Event(GET_SNAP));
		}
	}
}