package model.dates.eventsList.singleEvent.mediaSlider {
	import model.Settings;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Family
	 */
	public class MediaManager extends EventDispatcher {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const NO_MEDIA_FOUND : String = "noMediaFound";
		public static const ITEM_CHANGED : String = "itemChanged";		public static const CLEAR : String = "clear";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;		private var _settings : Settings;

		private var _itemsList : XMLList;
		private var _index : int;

		private var _autoplay : Boolean;
		private var _autoplayTimer : Timer;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function MediaManager() : void {
			_controller = Controller.getInstance();
			_settings = _controller.settings;
			
			_autoplay = _settings.mediaDefaultAutoplay;
			var autoplayTime : Number = 1000 * _settings.mediaShowDuration;
			_autoplayTimer = new Timer(autoplayTime, 1);
			
			_itemsList = new XMLList();
			_index = 0;
			
			_autoplayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoplayTimeCompleteHandler);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function updateItemsList(itemsListXmlList : XMLList) : void {
			stopCountDown();
			
			_itemsList = itemsListXmlList;
			
			_index = 0;
			dispatchEvent(new Event(ITEM_CHANGED));
		}

		public function manage() : void {
			if (_autoplay == true) {
				index++;
			}
		}

		public function startCountDown() : void {
			if (_autoplay == true) {
				_autoplayTimer.reset();
				_autoplayTimer.start();
			}
		}

		public function stopCountDown() : void {
			_autoplayTimer.stop();
		}

		public function clear() : void {
			_itemsList = new XMLList();
			dispatchEvent(new Event(CLEAR));
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get isEmpty() : Boolean {
			return _itemsList.length() == 0 ? true : false;
		}

		public function get index() : int {
			return _index;
		}

		public function set index(index : int) : void {
			if ((isEmpty == true) || (_itemsList.length() == 1)) {
				return;
			}
			
			_index = MathUtils.getInRange(index, 0, _itemsList.length() - 1, true);
			
			dispatchEvent(new Event(ITEM_CHANGED));
		}

		public function get curItemType() : String {
			return _itemsList[_index] == null ? "" : _itemsList[_index].@type;
		}

		public function get curItemUrl() : String {
			return _itemsList[_index] == null ? "" : _itemsList[_index].@url;
		}

		public function get curItemVidThumbUrl() : String {
			return _itemsList[_index] == null ? "" : _itemsList[_index].@vidThumbUrl;
		}

		public function get autoplay() : Boolean {
			return _autoplay;
		}

		public function set autoplay(autoplay : Boolean) : void {
			_autoplay = autoplay;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function autoplayTimeCompleteHandler(event : TimerEvent) : void {
			manage();
		}
	}
}
