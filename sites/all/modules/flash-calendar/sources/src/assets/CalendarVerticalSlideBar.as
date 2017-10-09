package assets {
	import graphics.Rect;

	import other.MultilayerRect;

	import uiElements.slider.SlideBar;

	import flash.display.Sprite;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class CalendarVerticalSlideBar extends SlideBar {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private static const LINE_CORNER_RADIUS : Number = 5;
		private static const HEAD_CORNER_RADIUS : Number = 5;

		private static const BASE_LINE_ALPHA : Number = 0.8;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _width : Number;		private var _height : Number;

		private var _headPercent : Number;

		private var _bgColor : int;
		private var _headColor : int;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function CalendarVerticalSlideBar(width : Number, height : Number, lineColor : int, headColor : int, lineWidth : Number = 2, headWidth : Number = 6) : void {
			_headPercent = 0.2;
			
			_width = width;			_height = height;
			
			_bgColor = lineColor;
			_headColor = headColor;
			
			var sprite : Sprite = new Sprite();
			
			var bg : Rect = new Rect(lineWidth, _height);
			bg.name = "bg";
			bg.fillColor = _bgColor;
			bg.fillAlpha = BASE_LINE_ALPHA;
			bg.cornerRadius = LINE_CORNER_RADIUS;
			bg.update();
			sprite.addChild(bg);
			
			var head : MultilayerRect = new MultilayerRect();
			head.name = "head";
			head.width = headWidth;
			head.height = _height * _headPercent;
			head.fillColor = headColor;
			head.cornerRadius = HEAD_CORNER_RADIUS;
			head.buttonMode = true;
			sprite.addChild(head);
			
			super(sprite, SlideBar.DIRECTION_VERTICAL);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		override public function disable() : void {
			super.disable();
			_sprite.visible = false;
		}

		override public function enable() : void {
			super.enable();
			_sprite.visible = true;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get x() : Number {
			return _sprite.x;
		}

		public function set x(x : Number) : void {
			_sprite.x = x;
		}

		public function get y() : Number {
			return _sprite.y;
		}

		public function set y(y : Number) : void {
			_sprite.y = y;
		}

		public function get width() : Number {
			return _width;
		}

		public function set width(width : Number) : void {
			if (_width != width) {
				_width = width;
				update();
			}
		}

		public function get height() : Number {
			return _height;
		}

		public function set height(height : Number) : void {
			if (_height != height) {
				_height = height;
				update();
			}
		}

		public function get headPercent() : Number {
			return _headPercent;
		}

		public function set headPercent(headPercent : Number) : void {
			if((_headPercent == headPercent) || (headPercent == 0)) {
				return;
			}
			_headPercent = headPercent;
			update();
		}

		public function set bgColor(color : int) : void {
			if (_bgColor != color) {
				_bgColor = color;
				update();
			}
		}

		public function set headColor(color : int) : void {
			if (_headColor != color) {
				_headColor = color;
				update();
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function update() : void {
			_bg.x = (_width - _bg.width) / 2;
			_bg.y = 0;
			_bg.height = _height;
			Rect(_bg).update();
			
			_head.height = _height * _headPercent;
			
			updateHeadPos();
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
	}
}
