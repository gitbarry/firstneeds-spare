package model {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class Container extends EventDispatcher {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		public static const UPDATE_RECT : String = "updateRect";		public static const UPDATE_ALPHA : String = "updateAlpha";

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		protected var _controller : Controller;

		protected var _rect : Rectangle;

		protected var _alpha : Number;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function Container() : void {
			_controller = Controller.getInstance();
			
			_rect = new Rectangle();
			
			_alpha = 1;
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get x() : Number {
			return _rect.x;
		}

		public function set x(x : Number) : void {
			if (_rect.x != x) {
				_rect.x = x;
				updateRect();
			}
		}

		public function get y() : Number {
			return _rect.y;
		}

		public function set y(y : Number) : void {
			if (_rect.y != y) {
				_rect.y = y;
				updateRect();
			}
		}

		public function get width() : Number {
			return _rect.width;
		}

		public function set width(width : Number) : void {
			if (_rect.width != width) {
				_rect.width = width;
				updateRect();
			}
		}

		public function get height() : Number {
			return _rect.height;
		}

		public function set height(height : Number) : void {
			if (_rect.height != height) {
				_rect.height = height;
				updateRect();
			}
		}

		public function get alpha() : Number {
			return _alpha;
		}

		public function set alpha(alpha : Number) : void {
			if (_alpha != alpha) {
				_alpha = alpha;
				updateAlpha();
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		protected function updateRect() : void {
			dispatchEvent(new Event(UPDATE_RECT));
		}
		
		protected function updateAlpha() : void {
			dispatchEvent(new Event(UPDATE_ALPHA));
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
