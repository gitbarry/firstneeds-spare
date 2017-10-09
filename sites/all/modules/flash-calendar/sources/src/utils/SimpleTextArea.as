package utils {
	import assets.CalendarVerticalSlideBar;

	import graphics.Rect;

	import model.Settings;

	import uiElements.slider.SlideBar;
	import uiElements.text.AdvancedTextField;
	import uiElements.text.TFUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;

	/**
	 * @author Robert Soghbatyan (robert.sogbatyan@gmail.com)
	 */
	public class SimpleTextArea {
		////////////////////////////////////////////////////////////////////////////////////////
		// Events                                                                             //
		////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		// Constants                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private const SLIDE_BAR_WIDTH : Number = 4;
		private const SLIDE_BAR_PADDING : Number = 4;
		
		
		////////////////////////////////////////////////////////////////////////////////////////
		// Variables                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private var _controller : Controller;		private var _settings: Settings;
		
		private var _sprite : Sprite;
		private var _mask : Rect;

		private var _bg : Rect;

		private var _rect : Rectangle;

		private var _text : String;
		private var _htmlText : String;
		private var _cssText : String;
		private var _tf : AdvancedTextField;

		private var _scrollbar : CalendarVerticalSlideBar;

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Constructor                                                                        //
		////////////////////////////////////////////////////////////////////////////////////////
		public function SimpleTextArea() : void {
			_controller = Controller.getInstance();
			_settings = _controller.settings;
			
			_sprite = new Sprite();
			_mask = new Rect();
			_sprite.addChild(_mask);
			_sprite.mask = _mask;
			
			_bg = new Rect();
			_bg.fillAlpha = 0;
			_sprite.addChild(_bg);
			
			_rect = new Rectangle();
			
			_tf = new AdvancedTextField();
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.align = "justify";
			_sprite.addChild(_tf);
			
			var sliderHeadColor : int = _settings.eventsListHeaderColor;
			var sliderBgColor : int = _settings.eventsListHeaderbgColors[0];
			_scrollbar = new CalendarVerticalSlideBar(SLIDE_BAR_WIDTH, 0, sliderBgColor, sliderHeadColor, SLIDE_BAR_WIDTH, SLIDE_BAR_WIDTH);
			_scrollbar.mWheelObj = _sprite;
			_scrollbar.y = SLIDE_BAR_PADDING;
			_sprite.addChild(_scrollbar.sprite);
			
			_scrollbar.addEventListener(SlideBar.HEAD_POS_CHANGED, scrollLevelChangedHandler);
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Public Methods                                                                     //
		////////////////////////////////////////////////////////////////////////////////////////
		public function init(text : String, htmlText : String = "", cssText : String = "") : void {
			_tf.styleSheet = null;
			_tf.text = "";
			
			_text = text;
			
			_htmlText = TFUtils.validateHtml(htmlText);
			_cssText = cssText;
			
			updateContent();
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Getters & Setters                                                                  //
		////////////////////////////////////////////////////////////////////////////////////////
		public function get sprite() : Sprite {
			return _sprite;
		}

		public function get x() : Number {
			return _rect.x;
		}

		public function set x(x : Number) : void {
			_rect.x = x;
			update();
		}

		public function get y() : Number {
			return _rect.y;
		}

		public function set y(y : Number) : void {
			_rect.y = y;
			update();
		}

		public function get width() : Number {
			return _rect.width;
		}

		public function set width(width : Number) : void {
			_rect.width = width;
			update();
		}

		public function get height() : Number {
			return _rect.height;
		}

		public function set height(height : Number) : void {
			_rect.height = height;
			update();
		}

		public function set font(font : String) : void {
			_tf.font = font;
			_scrollbar.level = 0;
			_tf.y = 0;
			update();
		}

		public function set fontSize(size : int) : void {
			_tf.size = size;
			_scrollbar.level = 0;
			_tf.y = 0;
			update();
		}

		public function set fontColor(color : int) : void {
			_tf.color = color;
			_scrollbar.level = 0;
			_tf.y = 0;
			update();
		}

		/*public function set text(text : String) : void {
		_tf.text = text;
		_scrollbar.level = 0;
		_tf.y = 0;
		update();
		}
		
		public function set htmlText(htmlText : String) : void {
		_tf.htmlText = htmlText;
		_scrollbar.level = 0;
		_tf.y = 0;
		update();
		}
		
		public function set css(css : StyleSheet) : void {
		_tf.styleSheet = css;
		_scrollbar.level = 0;
		_tf.y = 0;
		update();
		}*/

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Private Methods                                                                    //
		////////////////////////////////////////////////////////////////////////////////////////
		private function update() : void {
			_sprite.x = _rect.x;
			_sprite.y = _rect.y;
			
			_mask.width = _rect.width;
			_mask.height = _rect.height;
			
			_bg.width = _rect.width;
			_bg.height = _rect.height;
			
			_scrollbar.height = _rect.height - 2 * SLIDE_BAR_PADDING;
			_scrollbar.x = _rect.width - _scrollbar.width - SLIDE_BAR_PADDING;
			
			_tf.width = _rect.width - _scrollbar.width;
			if (_tf.height < _rect.height) {
				_tf.y = 0;
				_scrollbar.disable();
				_tf.width = _rect.width;
			} else {
				_scrollbar.enable();
			}
		}

		private function updateContent() : void {
			if (_text != "") {
				_tf.text = _text;
				_scrollbar.level = 0;
				_tf.y = 0;
				update();
			} else if (_htmlText != "") {
				if (_cssText != "") {
					var css : StyleSheet = new StyleSheet();
					css.parseCSS(_cssText);
					_tf.styleSheet = css;
				}
				
				_tf.htmlText = _htmlText;
				_scrollbar.level = 0;
				_tf.y = 0;
				update();
			}
		}

		
		////////////////////////////////////////////////////////////////////////////////////////
		// Listeners                                                                          //
		////////////////////////////////////////////////////////////////////////////////////////
		private function scrollLevelChangedHandler(event : Event) : void {
			_tf.y = _scrollbar.headPos * (_rect.height - _tf.height);
		}
	}
}
