package model {
	import model.dates.Dates;
	import model.header.Header;

	import realTimeTweener.RealTimeTweener;

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class App extends Container {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const VIEW_STATE_CHANGED : String = "viewStateChanged";		public static const VIEW_SIZE_CHANGED : String = "viewSizeChanged";		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _settings : Settings;
		
		private var _viewSize : String;
		private var _viewState : String;

		private var _bgStrokeWidth : Number;
		private var _bgRect : Rectangle;

		private var _header : Header;
		private var _dates : Dates;
		private var _footer : Footer;
		
		private var _sizeTweener : RealTimeTweener;
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function App() : void {
			super();
			
			_controller = Controller.getInstance();			_settings = _controller.settings;
			
			_viewSize = _settings.startViewSize;
			_viewState = _settings.startViewState;
			
			_rect.width = _viewSize == Settings.VIEW_SIZE_MIN ? _settings.appMinWidth : _settings.appMaxWidth;
			_rect.height = _viewSize == Settings.VIEW_SIZE_MIN ? _settings.appMinHeight : _settings.appMaxHeight;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function init() : void {
			_bgStrokeWidth = Settings.STROKE_WIDTH;
			_bgRect = new Rectangle();
			
			_header = new Header();
			_dates = new Dates();
			_footer = new Footer();
			
			_sizeTweener = new RealTimeTweener(this, _controller.stage);
			_sizeTweener.multiplier = Settings.REAL_TIME_TWEENER_MULTIPLIER;
			
			viewState = _settings.startViewState;
			
			updateRect();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get bgRect() : Rectangle {
			return _bgRect;
		}
		
		public function get header() : Header {
			return _header;
		}
		
		public function get dates() : Dates {
			return _dates;
		}
		
		public function get footer() : Footer {
			return _footer;
		}
		

		public function get viewSize() : String {
			return _viewSize;
		}

		public function set viewSize(viewSize : String) : void {
			if ((_viewState == Settings.VIEW_STATE_EVENT) && (viewSize == Settings.VIEW_SIZE_MIN)) {
				return;
			}
			
			_viewSize = viewSize;
			updateViewSize();
		}

		public function get viewState() : String {
			return _viewState;
		}

		public function set viewState(viewState : String) : void {
			_viewState = viewState;
			
			if (_viewState == Settings.VIEW_STATE_EVENT) {
				viewSize = Settings.VIEW_SIZE_MAX;
			}
			
			dispatchEvent(new Event(VIEW_STATE_CHANGED));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		override protected function updateRect() : void {
			var width : Number = _rect.width;			var height : Number = _rect.height;
			
			var headerHeight : Number = _settings.headerHeight;			var footerHeight : Number = _settings.footerHeight;
			
			_bgRect.x = _bgStrokeWidth / 2;
			_bgRect.y = _bgStrokeWidth / 2;
			_bgRect.width = width - _bgStrokeWidth;
			_bgRect.height = height - _bgStrokeWidth;
			
			_header.x = 0;
			_header.y = 0;
			_header.width = width;
			_header.height = headerHeight;
			
			_dates.x = 0;
			_dates.y = headerHeight;
			_dates.width = width;
			_dates.height = height - headerHeight - footerHeight;
			
			_footer.x = 0;
			_footer.y = height - footerHeight;
			_footer.width = width;
			_footer.height = footerHeight;

			super.updateRect();
		}
		
		private function updateViewSize() : void {
			var destWidth : Number = _viewSize == Settings.VIEW_SIZE_MIN ? _settings.appMinWidth : _settings.appMaxWidth;
			var destHeight : Number  = _viewSize == Settings.VIEW_SIZE_MIN ? _settings.appMinHeight : _settings.appMaxHeight;
			
			_sizeTweener.tween("width", destWidth);			_sizeTweener.tween("height", destHeight);
			
			dispatchEvent(new Event(VIEW_SIZE_CHANGED));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
