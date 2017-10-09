package model.dates.eventsList.singleEvent.mediaSlider {
	import model.Container;
	import model.Settings;

	import flash.events.Event;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class MediaSlider extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const VISIBILITY_CHANGED : String = "visibilityChanged";
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const CTRLS_SPACING : Number = 10;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		
		private var _isVisible : Boolean;

		private var _mediaManager : MediaManager;
		
		private var _ctrls : Ctrls;
		private var _vidCtrls : VidCtrls;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function MediaSlider() : void {
			super();
			
			_settings = _controller.settings;
			
			_mediaManager = new MediaManager();
			
			_ctrls = new Ctrls();
			_vidCtrls = new VidCtrls();
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function updateMediaXmlList(mediaXmlList : XMLList) : void {
			_mediaManager.updateItemsList(mediaXmlList);
		}

		public function clear() : void {
			_mediaManager.clear();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get isVisible() : Boolean {
			return _isVisible;
		}
		
		public function set isVisible(isVisible : Boolean) : void {
			_isVisible = isVisible;
			dispatchEvent(new Event(VISIBILITY_CHANGED));
		}
		
		public function get mediaManager() : MediaManager {
			return _mediaManager;
		}

		public function get ctrls() : Ctrls {
			return _ctrls;
		}

		public function get vidCtrls() : VidCtrls {
			return _vidCtrls;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			var width : Number = _rect.width;			var height : Number = _rect.height;
			
			_ctrls.x = CTRLS_SPACING;
			_ctrls.y = height - CTRLS_SPACING - _ctrls.height;
			
			_vidCtrls.x = _ctrls.width + 2 * CTRLS_SPACING;
			_vidCtrls.y = height - CTRLS_SPACING - _vidCtrls.height;
			_vidCtrls.width = width - _ctrls.width - 3 * CTRLS_SPACING;
			
			super.updateRect();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
