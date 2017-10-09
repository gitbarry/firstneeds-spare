package model.dates.eventsList {
	import flash.events.Event;
	import uiElements.text.TFUtils;
	import model.Container;
	import model.Lang;
	import model.Settings;

	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class EventsListHeader extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_TITLE_TEXT : String = "updateTitleText";		public static const UPDATE_CTRLS_VISIBILITY : String = "updateCtrlsVisibility";		public static const UPDATE_OPENED_EVENT_INDEX : String = "updateOpenedEventIndex";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private const SPACE : Number = 10;

		public static const BTN_SIZE : Number = 30;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;		private var _lang : Lang;

		private var _eventsListManager : EventsListManager;

		private var _titleRect : Rectangle;
		private var _titleText : String;
		private var _ctrlsRect : Rectangle;
		private var _ctrlsBtnPrevRect : Rectangle;		private var _ctrlsOpenedEventIndexRect : Rectangle;		private var _openedEventIndexText : String;		private var _ctrlsBtnNextRect : Rectangle;		private var _btnCloseRect : Rectangle;

		private var _isCtrlsVisible : Boolean;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function EventsListHeader(eventsListManager : EventsListManager) : void {
			super();
			
			_settings = _controller.settings;			_lang = _controller.lang;
			
			_eventsListManager = eventsListManager;
			
			_rect.height = _controller.settings.eventsListHeaderHeight;
			
			var font : String = Settings.FONT;
			var fontSize : int = _settings.eventsListHeaderFontSize;
			
			_titleRect = new Rectangle();
			
			_ctrlsRect = new Rectangle();
						_ctrlsBtnPrevRect = new Rectangle();			_ctrlsBtnPrevRect.width = BTN_SIZE;			_ctrlsBtnPrevRect.height = BTN_SIZE;
						_ctrlsOpenedEventIndexRect = new Rectangle();
			_ctrlsOpenedEventIndexRect = TFUtils.getTFMetrics("00/00", font, fontSize);
			_ctrlsOpenedEventIndexRect.x = BTN_SIZE;
						_ctrlsBtnNextRect = new Rectangle();
			_ctrlsBtnNextRect.x = _ctrlsOpenedEventIndexRect.x + _ctrlsOpenedEventIndexRect.width;			_ctrlsBtnNextRect.width = BTN_SIZE;			_ctrlsBtnNextRect.height = BTN_SIZE;
			
			var ctrlsRectHeight : Number = _ctrlsOpenedEventIndexRect.height > BTN_SIZE ? _ctrlsOpenedEventIndexRect.height : BTN_SIZE;
			_ctrlsRect.width = _ctrlsBtnPrevRect.width + _ctrlsOpenedEventIndexRect.width + _ctrlsBtnNextRect.width;
			_ctrlsRect.height = ctrlsRectHeight;
			_ctrlsBtnPrevRect.y = (ctrlsRectHeight - _ctrlsBtnPrevRect.height) / 2;			_ctrlsOpenedEventIndexRect.y = (ctrlsRectHeight - _ctrlsOpenedEventIndexRect.height) / 2;			_ctrlsBtnNextRect.y = (ctrlsRectHeight - _ctrlsBtnNextRect.height) / 2;
			
			_btnCloseRect = new Rectangle();
			_btnCloseRect.width = BTN_SIZE;			_btnCloseRect.height = BTN_SIZE;			
			_isCtrlsVisible = _eventsListManager.isEventOpened;
			
			_eventsListManager.addEventListener(EventsListManager.UPDATE_EVENTS, updateEventsHandler);			_eventsListManager.addEventListener(EventsListManager.IS_EVENT_OPENED_CHANGED, updateIsEventOpenedHandler);			_eventsListManager.addEventListener(EventsListManager.OPENED_EVENT_INDEX_CHANGED, openedEventIndexChangedHandler);
			
			updateRect();
			updateTitleText();
			updateOpenedEventIndexText();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get eventsListManager() : EventsListManager {
			return _eventsListManager;
		}

		public function get titleRect() : Rectangle {
			return _titleRect;
		}

		public function get titleText() : String {
			return _titleText;
		}
		
		public function get ctrlsRect() : Rectangle {
			return _ctrlsRect;
		}
		
		public function get ctrlsBtnPrevRect() : Rectangle {
			return _ctrlsBtnPrevRect;
		}
		
		public function get ctrlsOpenedEventIndexRect() : Rectangle {
			return _ctrlsOpenedEventIndexRect;
		}
		
		public function get openedEventIndexText() : String {
			return _openedEventIndexText;
		}
		
		public function get ctrlsBtnNextRect() : Rectangle {
			return _ctrlsBtnNextRect;
		}
		
		public function get btnCloseRect() : Rectangle {
			return _btnCloseRect;
		}
		
		public function get isCtrlsVisible() : Boolean {
			return _isCtrlsVisible;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			var width : Number = _rect.width;			var height : Number = _rect.height;
			
			var isEventOpened : Boolean = _eventsListManager.isEventOpened;
			
			_titleRect.x = SPACE;			_titleRect.width = isEventOpened == true ? width - _ctrlsRect.width - _btnCloseRect.width - 4 * SPACE : _rect.width - _btnCloseRect.width - 3 * SPACE;
			_titleRect.height = height;
			
			_ctrlsRect.x = width - _btnCloseRect.width - 2 * SPACE - _ctrlsRect.width;
			_ctrlsRect.y = (height - _ctrlsRect.height) / 2;
			
			_btnCloseRect.x = width - _btnCloseRect.width - SPACE;			_btnCloseRect.y = (height - _btnCloseRect.height) / 2;			
			super.updateRect();
		}
		
		private function updateTitleText() : void {
			var eventsList : Array = _eventsListManager.singleEvents;
			var eventsLength : uint = eventsList.length;
			
			var eventsText : String = eventsLength == 1 ? _lang.event : _lang.events;
			_titleText = eventsLength + " " + eventsText;
			
			dispatchEvent(new Event(UPDATE_TITLE_TEXT));
		}
		
		private function updateOpenedEventIndexText() : void {
			var eventsList : Array = _eventsListManager.singleEvents;
			var eventsLength : uint = eventsList.length;
			
			var openedEventIndex : uint = eventsLength == 0 ? 0 : _eventsListManager.openedEventIndex + 1;
			
			_openedEventIndexText = String(openedEventIndex) + "/" + String(eventsLength);
			
			dispatchEvent(new Event(UPDATE_OPENED_EVENT_INDEX));
		}
		

		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function updateEventsHandler(event : Event) : void {
			updateTitleText();
			updateOpenedEventIndexText();
		}
		
		private function updateIsEventOpenedHandler(event : Event) : void {
			_isCtrlsVisible = _eventsListManager.isEventOpened;
			dispatchEvent(new Event(UPDATE_CTRLS_VISIBILITY));
		}

		private function openedEventIndexChangedHandler(event : Event) : void {
			updateOpenedEventIndexText();
		}
	}
}
